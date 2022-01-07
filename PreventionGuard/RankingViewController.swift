import UIKit
import FirebaseDatabase

class RankingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var rankingTableView: UITableView!

    let cellIdentifer: String = "type2"
    
    var rankArr: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("RankingViewController - viewDidLoad() called")
        
        rankingTableView.delegate = self
        rankingTableView.dataSource = self
        
        self.rankingTableView.layer.cornerRadius = 20
        // 선 제거
        //rankingTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    
        var ref: DatabaseReference!
        ref = Database.database().reference().child("Rank")
        
        ref.queryOrderedByValue().observeSingleEvent(of: .value, with: { (snapshot) in
            
            for child in snapshot.children { self.rankArr.append((child as! DataSnapshot).key) }
            
            // 테이블 뷰에 출력
            self.rankingTableView.reloadData()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return rankArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = rankingTableView.dequeueReusableCell(withIdentifier: "type3", for: indexPath) as! type3TableViewCell
    
        // 클릭 시 회색으로 변하지 않게 하기
        let background = UIView()
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        cell.nicknameLabel.text = rankArr[(rankArr.count - 1) - indexPath.row]
        cell.rankLabel.text = String(indexPath.row + 1) + "등"
        
        return cell
    }
    
    // 셀 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }

}
