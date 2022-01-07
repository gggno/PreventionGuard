import UIKit
import FirebaseDatabase
import FirebaseAuth
import SQLite3

class DeleteViewController: UIViewController, UIGestureRecognizerDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var pwdTxtField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    
    var dbsql = sqL()
    var keyboardDismissTabGesture : UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DeleteViewController - called")
        
        self.keyboardDismissTabGesture.delegate = self
        self.view.addGestureRecognizer(keyboardDismissTabGesture)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        print("DeleteViewcontroller - gestureRecognizer shouldReceive() called")
        
        if touch.view?.isDescendant(of: pwdTxtField) == true || touch.view?.isDescendant(of: deleteButton) == true {
            return false
        } else {
        view.endEditing(true)
        return true
        }
    }
    
    // MARK: - IBAction
    @IBAction func deleteButtonClick(_ sender: Any) {
       print("DeleteViewController - deleteButtonClick() called")
        
        if pwdTxtField.text!.isEmpty {
            print("failed = nil")
            
            let alert2 = UIAlertController(title: nil, message: "비밀번호를 다시 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
            
            let okAction2 = UIAlertAction(title: "확인", style: .default) { (action) in
            }
            
            alert2.addAction(okAction2)
            self.present(alert2, animated: false, completion: nil)
            
            return
            
        } else {
            
            let email: String = dbsql.getEmail()

            Auth.auth().signIn(withEmail: email, password: pwdTxtField.text ?? "") { (user, error) in
                
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                if error == nil {
                    
                    let uid = (Auth.auth().currentUser?.uid)!
                    let nickName = self.dbsql.getNickName()
                    
                    print(uid)
                    
                    ref.child("Name").child("\(uid)").removeValue()
                    ref.child("Rank").child("\(nickName)").removeValue()
                    ref.child("User").child("\(uid)").removeValue()
                    
                    Auth.auth().currentUser?.delete()
                    
                    print("탈퇴되었습니다.")
                    
                    self.dbsql.delete()
                    
                    do {
                        try Auth.auth().signOut()
                    } catch let signOutError as NSError {
                      print("Error signing out: %@", signOutError)
                    }
                    
                    guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") else {return}
                    
                    vc.modalTransitionStyle = .crossDissolve
                    vc.modalPresentationStyle = .fullScreen
                    
                    self.present(vc, animated: true)
                    
//                    let alert3 = UIAlertController(title: nil, message: "탈퇴되었습니다.", preferredStyle: UIAlertController.Style.alert)
//
//                    let okAction3 = UIAlertAction(title: "확인", style: .default) { (action) in
//                    }
//
//                    alert3.addAction(okAction3)
//                    self.present(alert3, animated: false, completion: nil)
                }
            }
            
        
        }
    }
    
}
