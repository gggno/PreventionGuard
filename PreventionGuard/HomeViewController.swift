import UIKit
import SQLite3
import FirebaseDatabase
import FirebaseAuth

class HomeViewController: UIViewController,UITableViewDelegate, UITableViewDataSource
{
    //MARK: - IBOutlet
    @IBOutlet weak var homeTableView: UITableView!
    
    @IBOutlet weak var nikNameLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var characterImage: UIImageView!
    
    @IBOutlet weak var nickNamePrintLabel: UILabel!
    @IBOutlet weak var scorePrintLabel: UILabel!
    @IBOutlet weak var levelPrintLabel: UILabel!
    
    let cellIdentifer: String = "type2"
    
    var dbsql = sqL()
    
    var key: [String] = []
    var value: [Int] = []
    
    var copyList: [String] = []
    var copyScore: [Int] = []
    var realList: [String] = []
    var realListScore: [Int] = []
    var arr:[PreventionList] = []
    var arr2:[PreventionList] = []
    
    var homeNickName: String = ""
    var homeScore: Int = 0
    var homeLevel: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HomeViewController - called")
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        
        // 선 제거
        homeTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        self.homeTableView.layer.cornerRadius = 15
        
        // 리스트 테이블에 값이 있는지 확인(로컬DB에 값이 있다면)
        if dbsql.getListSelecValue() == true {
            var date: String = ""
            
            date = nowDate()
            
            // 다음날이 되면
            if dbsql.selectDate() != date {
                dbsql.updateDate(date)
                dbsql.updateCnt(0)
                dbsql.initlist()
                dbsql.creatTable2()
            
                var ref: DatabaseReference!
                ref = Database.database().reference()
                
                let uid = (Auth.auth().currentUser?.uid)!
                
                ref.child("User").child("\(uid)").updateChildValues(["Date" : nowDate()])
                ref.child("User").child("\(uid)").updateChildValues(["Cnt" : 0])

                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let tagsSnap = snapshot.childSnapshot(forPath: "PreventionList")
                    let allChildTagsSnap = tagsSnap.children.allObjects as! [DataSnapshot]
                    var cnt = 0
                    
                    for tagChildSnap in allChildTagsSnap {
                        
                        var item: PreventionList = PreventionList()
                        
                        item.content = tagChildSnap.key
                        item.score = tagChildSnap.value as! Int
                        item.position = cnt
                        item.confirm = 0
                        self.arr.append(item)
                        cnt = cnt + 1
                    }
                    cnt = 0
                    var check = [Int](repeating: 0, count: self.arr.count)
                    
                    while cnt < 5 {
                        var number = Int.random(in: 0...self.arr.count-1)
                        
                        if check[number] == 0 {
                            self.dbsql.insertListData(self.arr[number].content, self.arr[number].score, 0, cnt)
                            
                            check[number] = 1
                            cnt = cnt + 1
                            
                            var item: PreventionList = PreventionList()
                            
                            item.content = self.arr[number].content
                            item.score = self.arr[number].score
                            item.position = cnt
                            item.confirm = 0
                            
                            self.arr2.append(item)
                        }
                    }
                    // 테이블 뷰에 출력
                    self.homeTableView.reloadData()
                })
                
            } else {
                arr2 = dbsql.selectListValue()
                homeTableView.reloadData()
            }
            
        } else {
            //파이어베이스에서 값 가져오기
            var ref: DatabaseReference!
            ref = Database.database().reference()
            
            dbsql.creatTable2()
            
            if dbsql.selectDate() != nowDate(){
                
                let uid = (Auth.auth().currentUser?.uid)!
                ref.child("User").child("\(uid)").updateChildValues(["Date" : nowDate()])
                ref.child("User").child("\(uid)").updateChildValues(["Cnt" : 0])
                
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let tagsSnap = snapshot.childSnapshot(forPath: "PreventionList")
                    let allChildTagsSnap = tagsSnap.children.allObjects as! [DataSnapshot]
                    var cnt = 0
                    
                    for tagChildSnap in allChildTagsSnap {
                        
                        var item: PreventionList = PreventionList()
                        
                        item.content = tagChildSnap.key
                        item.score = tagChildSnap.value as! Int
                        item.position = cnt
                        item.confirm = 0
                        self.arr.append(item)
                        cnt = cnt + 1
                    }
                    cnt = 0
                    var check = [Int](repeating: 0, count: self.arr.count)
                    
                    while cnt < 5 {
                        var number = Int.random(in: 0...self.arr.count-1)
                       
                        if check[number] == 0 {
                            self.dbsql.insertListData(self.arr[number].content, self.arr[number].score, 0, cnt)
                            
                            check[number] = 1
                            cnt = cnt + 1
                            
                            var item: PreventionList = PreventionList()
                            
                            item.content = self.arr[number].content
                            item.score = self.arr[number].score
                            item.position = cnt
                            item.confirm = 0
                            
                            self.arr2.append(item)
                        }
                    }
                    // 테이블 뷰에 출력
                    self.homeTableView.reloadData()
                })
            }else {
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let tagsSnap = snapshot.childSnapshot(forPath: "PreventionList")
                    let allChildTagsSnap = tagsSnap.children.allObjects as! [DataSnapshot]
                    var cnt = 0
                    
                    for tagChildSnap in allChildTagsSnap {
                        
                        var item: PreventionList = PreventionList()
                        
                        item.content = tagChildSnap.key
                        item.score = tagChildSnap.value as! Int
                        item.position = cnt
                        item.confirm = 0
                        self.arr.append(item)
                        cnt = cnt + 1
                    }
                    cnt = 0
                    var check = [Int](repeating: 0, count: self.arr.count)
                    var limit = 5-self.dbsql.getCnt()
                    while cnt < limit {
                        var number = Int.random(in: 0...self.arr.count-1)
                        if check[number] == 0 {
                            self.dbsql.insertListData(self.arr[number].content, self.arr[number].score, 0, cnt)
                            
                            check[number] = 1
                            cnt = cnt + 1
                            
                            var item: PreventionList = PreventionList()
                            
                            item.content = self.arr[number].content
                            item.score = self.arr[number].score
                            item.position = cnt
                            item.confirm = 0
                            
                            self.arr2.append(item)
                        }
                    }
                    // 테이블 뷰에 출력
                    self.homeTableView.reloadData()
                })
            }
            
        }
        
        homeNickName = self.dbsql.getNickName()
        homeScore = self.dbsql.getScore()
        
        nickNamePrintLabel.text = homeNickName
        scorePrintLabel.text = String(homeScore)
        levelPrintLabel.text = String(getLevel(homeScore))
        
        if levelPrintLabel.text == "1" {
            characterImage.image = UIImage(named: "일반(1).png")
        }
        
        if levelPrintLabel.text == "2" {
            characterImage.image = UIImage(named: "메론빵(2).png")
        }
        
        if levelPrintLabel.text == "3" {
            characterImage.image = UIImage(named: "마스크(3).png")
        }
        
    }
    
    func getLevel(_ score: Int) -> Int {
        
        var tmp: Int = 0
        tmp=score/100
        
        switch(tmp){
        case 0: return 1
        case 1: return 2
        case 2: return 3
        default:
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr2.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = homeTableView.dequeueReusableCell(withIdentifier: "type2", for: indexPath) as! type2TableViewCell
        
        // 클릭 시 회색으로 변하지 않게 하기
        let background = UIView()
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        if arr2[indexPath.row].confirm == 1{
            cell.backgroundColor = UIColor.lightGray
        }
        cell.txtLabel.text = arr2[indexPath.row].content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        let cell = homeTableView.cellForRow(at: indexPath)!
        
        if arr2[indexPath.row].confirm == 0 {
            
            homeScore = homeScore + arr2[indexPath.row].score
            arr2[indexPath.row].confirm = 1
            
            scorePrintLabel.text = String(homeScore)
            levelPrintLabel.text = String(getLevel(homeScore))
            
            if levelPrintLabel.text == "1" {
                characterImage.image = UIImage(named: "일반(1).png")
            }
            
            if levelPrintLabel.text == "2" {
                characterImage.image = UIImage(named: "메론빵(2).png")
            }
            
            if levelPrintLabel.text == "3" {
                characterImage.image = UIImage(named: "마스크(3).png")
            }
            
            var ref2: DatabaseReference!
            ref2 = Database.database().reference()
            
            let uid = (Auth.auth().currentUser?.uid)!
            
            dbsql.updateScore(homeScore)
            dbsql.updateConfirm(indexPath.row)
            dbsql.updateCnt(dbsql.getCnt()+1)
            
            ref2.child("User").child("\(uid)").updateChildValues(["Score" : homeScore])
            ref2.child("User").child("\(uid)").updateChildValues(["Cnt" : dbsql.getCnt()])
            ref2.child("Rank").updateChildValues(["\(homeNickName)" : homeScore])
            cell.backgroundColor = UIColor.lightGray
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func nowDate() -> String {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMddhh:mm"
        dateFormatter.timeZone = NSTimeZone(name: "Ko_KR") as TimeZone?
        
        return dateFormatter.string(from: now)
    }
    
}
