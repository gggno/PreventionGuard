import UIKit
import SQLite3

class AchievementViewController: UIViewController {

    var dbsql = sqL()

    @IBOutlet weak var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startBtn.layer.cornerRadius = 15
    }
    
    @IBAction func btnClick(_ sender: Any) {
        
        let urlStirng = "ShootingGame://"
        
        if dbsql.getCnt() >= 3 {
            print("3개 이상임")
            
            if let appUrl = URL(string: urlStirng) {
                if(UIApplication.shared.canOpenURL(appUrl)) {
                    UIApplication.shared.open(appUrl, options: [:], completionHandler: nil)
                }else {
                    let showAlert = UIAlertController(title: "안내", message: "앱 작동 오류", preferredStyle: UIAlertController.Style.alert)
                }
            
            }
            
            
        } else {
            print("3개 미만임")
        }
    }
    


}
