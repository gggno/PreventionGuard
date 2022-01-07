import UIKit
import FirebaseDatabase
import FirebaseAuth
import SQLite3

class ViewController: UIViewController, UIGestureRecognizerDelegate {
        
    // MARK: - @IBOutlet
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
   
    var result: String = ""
    var copyuid: String = ""
    
    var copyemail: String = ""
    var copynickname: String = ""
    var copyscore: Int = 0
    var copydate: String = ""
    var copycnt: Int = 0
    
    var realEmail: String = ""
    var realNickName: String = ""
    var realScore: Int = 0
    var realDate: String = ""
    var realCnt: Int = 0
    
    var dbsql = sqL()

    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    var ref2: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.keyboardDismissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
        barClear()
        
        loginButton.layer.cornerRadius = 15
        signUpButton.layer.cornerRadius = 15
        
        ref2 = Database.database().reference()
        
        // 기존 로그인 기록이 있으면
        if dbsql.getAutoLoginSelectValue() == "1" {
            print("viewcontroller - getAutoLoginSelectValue() called")

            let moveScreen = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
            moveScreen?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
            moveScreen?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
            self.present(moveScreen!, animated: true, completion: nil)
        }
    }
    
    // MARK: - IBAction
    @IBAction func loginButtonClick(_ sender: Any) {
        
        var email = emailTxtField.text
        email = email! + "@test.com"
        guard let pw = pwdTxtField.text else {return}
        
        Auth.auth().signIn(withEmail: email!, password: pw) { (user, error) in
        
            guard let userid = Auth.auth().currentUser?.uid else {return}

            self.copyuid = userid
            self.result = pw

            if error == nil {
                // 로그인 성공
                
                self.dbsql.firebaseData() { (copyemail, copynickname, copyscore, copydate, copycnt) -> Void in
                    
                    self.dbsql.createTable()

                    self.realEmail = copyemail
                    self.realNickName = copynickname
                    self.realScore = copyscore
                    self.realDate = copydate
                    self.realCnt = copycnt
                    
                    self.dbsql.insertData(nickStr: self.realNickName, uidStr: self.dbsql.uid, scoreInt: self.realScore, autoStr: "1", emailStr: self.realEmail, dateStr: self.realDate, cntInt: self.realCnt)
                    self.dbsql.selectValue()
                    
                    let moveScreen = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController")
                    moveScreen?.modalPresentationStyle = .fullScreen //전체화면으로 보이게 설정
                    moveScreen?.modalTransitionStyle = .crossDissolve //전환 애니메이션 설정
                    self.present(moveScreen!, animated: true, completion: nil)
                    
                    print("로그인 성공!")

                }
                        
            } else {
                // 로그인 실패
                let alert = UIAlertController(title: "로그인 실패", message: "아이디 또는 비밀번호를 다시 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
                
                let okAction = UIAlertAction(title: "확인", style: .default) { (action) in
                }
                
                alert.addAction(okAction)
                self.present(alert, animated: false, completion: nil)
                
                print("로그인 실패...")
            }
        }
        
    }
    
    //키보드 디스미스
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("Viewcontroller - gestureRecognizer shouldReceive() called")
        
        if touch.view?.isDescendant(of: emailTxtField) == true || touch.view?.isDescendant(of: pwdTxtField) == true || touch.view?.isDescendant(of: loginButton) == true || touch.view?.isDescendant(of: signUpButton) == true {
            return false
        } else {
        view.endEditing(true)
        return true
        }
    }
    
    // 네비게이션바 투명
    func barClear() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    func nowDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        dateFormatter.timeZone = NSTimeZone(name: "Ko_KR") as TimeZone?
        
        return dateFormatter.string(from: now)
    }

}
