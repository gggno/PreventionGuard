import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignupViewController: UIViewController,UIGestureRecognizerDelegate {

    // MARK: - IBoutlet
    
    @IBOutlet weak var makeEmailTxtField: UITextField!
    @IBOutlet weak var makePwdTxtField: UITextField!
    @IBOutlet weak var makeNiknameTxtField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    var score: Int = 0
    var cnt: Int = 0
    var dbsql = sqL()
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("signupvc called")
        

        self.keyboardDismissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
        
        self.signUpButton.layer.cornerRadius = 15
        
        ref = Database.database().reference()
    }
    
    // MARK: - IBAction
    
    // 회원가입 구현
    @IBAction func signUpButtonClick(_ sender: Any) {
        print("SignUpViewcontroller - signUpButtonClick() called")

        var email = makeEmailTxtField.text
        email = email! + "@test.com"
        guard let pw = makePwdTxtField.text else {return}
        guard let nikName = makeNiknameTxtField.text else {return}
        
        var date = nowDate()
        
        Auth.auth().createUser(withEmail: email!, password: pw) { (authResut, error) in
            guard let user = authResut?.user else {return}
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            if error == nil {
                // 회원가입 정상 처리 후 그 이후 코드 작성
                self.dbsql.delete()
                self.ref.child("User").child("\(uid)").setValue(["Email":email,"NinName":nikName, "Date":date, "Score":self.score, "Cnt":self.cnt])
                                
                self.ref.child("Name").child("\(uid)").updateChildValues(["\(nikName)":"true"])

                self.ref.child("Rank").updateChildValues(["\(nikName)":self.score])

                let alert = UIAlertController(title: "회원가입 성공", message: "로그인 후 이용 가능합니다.", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                }
                
                alert.addAction(okAction)
                
                self.present(alert, animated: false, completion: nil)

                print("\(email)님의 회원가입이 성공적으로 이루어졌습니다!")                
            } else {
                // 회원가입 실패 후 그 이후 코드 작성
                
                
                
                print("회원가입에 실패하였습니다...")
            }
        }
    }
    
    // 키보드 내려가기
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if touch.view?.isDescendant(of: makeEmailTxtField) == true || touch.view?.isDescendant(of: makePwdTxtField) == true || touch.view?.isDescendant(of: makeNiknameTxtField) == true || touch.view?.isDescendant(of: signUpButton) == true {
            return false
        } else {
        view.endEditing(true)
        return true
        }
    }
    
    func nowDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        dateFormatter.timeZone = NSTimeZone(name: "Ko_KR") as TimeZone?

        return dateFormatter.string(from: now)
    }

}
