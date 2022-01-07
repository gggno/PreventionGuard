import UIKit
import FirebaseAuth

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var mainTableView: UITableView!
    
    let cellIdentifier: String = "type1"
    
    let information: [String] = ["이름", "아이디"]
    let general: [String] = ["회원탈퇴", "로그아웃"]
    
    let dbsql = sqL()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        header()
    }

    // 데이터 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return general.count
        case 1:
            return general.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = mainTableView.dequeueReusableCell(withIdentifier: "type1", for: indexPath) as! type1TableViewCell
        
        let text: String = general[indexPath.row]
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    // 섹션 구분
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    // 섹션 종류
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "기타"
    }
    
    // 셀 클릭
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                self.performSegue(withIdentifier: "delete", sender: nil)
            }
            
            if indexPath.row == 1 {
                // 로그아웃
                dbsql.delete()
                dbsql.logout()
                
                do {
                    try Auth.auth().signOut()
                } catch let signOutError as NSError {
                  print("Error signing out: %@", signOutError)
                }
                
                guard let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") else {return}
                
                vc.modalTransitionStyle = .crossDissolve
                vc.modalPresentationStyle = .fullScreen
                
                self.present(vc, animated: true)
            }
        }
        
        
    
    }

    // 테이블 뷰 header 부분
    func header() {
        let header = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 50))
        header.backgroundColor = .systemBackground

        let headerLabel = UILabel(frame: header.bounds)
        headerLabel.text = "설정"
        headerLabel.font = UIFont.systemFont(ofSize: 20)
        headerLabel.textAlignment = .center
        header.addSubview(headerLabel)
        
        mainTableView.tableHeaderView = header
    }
    
//    // 테이블 뷰 footer 부분
//    func footer() {
//        let footer = UIView(frame:  CGRect(x: 0, y: 0, width: view.frame.size.width, height: 100))
//        footer.backgroundColor = .gray
//
//        let footerButton = UIButton(frame: footer.bounds)
//        footerButton.setTitle("로그아웃", for: UIControl.State.normal)
//        footerButton.addTarget(self, action: #selector(self.buttonClick(_:)), for: .touchUpInside)
//
//        footer.addSubview(footerButton)
//
//       footerButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        footerButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        footerButton.centerXAnchor.constraint(equalTo: footer.centerXAnchor).isActive = true
//        footerButton.centerYAnchor.constraint(equalTo: footer.centerYAnchor).isActive = true
//
//        mainTableView.tableFooterView = footer
//    }
//
//    @objc func buttonClick(_ sender: UIButton) {
//        print("로그아웃 버튼 클릭!")
//
//    }

}
