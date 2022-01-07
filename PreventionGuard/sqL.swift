import Foundation
import FirebaseAuth
import FirebaseDatabase
import SQLite3
import UIKit
import FirebaseInstallations

class sqL {
    
    var uid: String = ""
    var email: String = ""
    var nickName: String = ""
    var score: Int = 0
    var date: String = ""
    var cnt: Int = 0
    var autoLogin: String = "0"
    var version: String = ""
    
    var copyNickName: String = ""
    var copyScore: Int = 0
    var copyAutoLogin: String = ""
    var copyemail: String = ""
    var copyDate: String = ""
    var copyCnt: Int = 0
    
    var homeNickName: String = ""
    var homeScore: Int = 0
    
    var ref3: DatabaseReference!
    
    var db: OpaquePointer?
    
    init() {
        self.db = createDB()
    }
    
    func createDB() -> OpaquePointer? {
        
        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("UserTable.sqlite")
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath.path, &db) != SQLITE_OK {
            print("Error while creating db")
            return nil
        } else {
            print("Database has been created with path UserTable.sqlite")
            return db
        }
    }
    
    func createTable() {
        
        let createTableQuery = "CREATE TABLE IF NOT EXISTS user (nickname TEXT, uid TEXT, score INTEGER, autologin TEXT, email TEXT, date TEXT, cnt INTEGER)"
        
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createTableQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                
                print("table1 creation has been successfully done")
            }
            else {
                print("table1 creation failure")
            }
        } else {
            print("Preparation for creating table1 has been failed")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func creatTable2() {
        
        let createTable2Query = "CREATE TABLE IF NOT EXISTS list (content TEXT, listScore INTEGER, confirm INTEGER, positions INTEGER)"
        
        var createTablePtr: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, createTable2Query, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                
                print("table2 creation has been successfully done")
            }
            else {
                print("table2 creation failure")
            }
        } else {
            print("Preparation for creating table2 has been failed")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func insertData(nickStr: String, uidStr: String, scoreInt: Int, autoStr: String, emailStr: String, dateStr: String, cntInt: Int) {
        print("sqL - insertData() called")
        
        var createTablePtr : OpaquePointer? = nil
        
        let insertQeury : String = "INSERT INTO user (nickname, uid, score, autologin, email, date, cnt) VALUES (?,?,?,?,?,?,?);"
        
        if sqlite3_prepare(db, insertQeury, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insertData(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(createTablePtr, 1, nickStr, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 2, uidStr, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 3, Int32(scoreInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 4, autoStr, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 5, emailStr, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 6, dateStr, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 7, Int32(cntInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("insert fail :: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func insertListData(_ contentStr : String, _ listScoreInt: Int, _ confirmInt: Int, _ positionsInt: Int) {
        print("sqL - insertListData() called")
        var createTablePtr : OpaquePointer? = nil
        
        let insertQeury : String = "INSERT INTO list (content, listScore, confirm, positions) VALUES (?,?,?,?);"
        
        if sqlite3_prepare(db, insertQeury, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insertListData(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
        
        if sqlite3_bind_text(createTablePtr, 1, contentStr, -1, SQLITE_TRANSIENT) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 2, Int32(listScoreInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 3, Int32(confirmInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 4, Int32(positionsInt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("insert fail :: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func updateAutoLogin() {
        print("sqL - updateAutoLogin() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        let updateQuery = "UPDATE user SET autoLogin = '1' WHERE autoLogin = '0'"
        
        if sqlite3_prepare_v2(self.db, updateQuery, -1, &createTablePtr, nil) == SQLITE_OK {
            
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("\(autoLogin)")
                print("Successfully updated")
            } else {
                print("Could not update")
            }
        } else {
            print("UPDATE createTablePtr could not be prepared")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func selectDate()->String{
        var createTablePtr: OpaquePointer? = nil
        var date: String = ""
        let selectQuery = "SELECT date FROM user"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getversionselectValue(): v1 \(errMsg)")
            return "fail"
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            date = String(cString: sqlite3_column_text(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return date
    }
    
    func selectValue() {
        print("sqL - selectValue() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        let selectQuery = "SELECT * FROM user"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectValue(): v1 \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            
            let nik = String(cString: sqlite3_column_text(createTablePtr, 0))
            let uid = String(cString: sqlite3_column_text(createTablePtr, 1))
            let score = sqlite3_column_int(createTablePtr, 2)
            let auto = String(cString: sqlite3_column_text(createTablePtr, 3))
            let email = String(cString: sqlite3_column_text(createTablePtr, 4))
            let date = String(cString: sqlite3_column_text(createTablePtr, 5))
            let cnt = sqlite3_column_int(createTablePtr, 6)
            
            print("read value nik : \(nik) uid : \(uid) score : \(score) auto : \(auto), email : \(email), date : \(date), cnt : \(cnt)")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func selectListValue() -> [PreventionList] {
        print("sqL - selectListValue() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        var arr: [PreventionList] = []
        
        let selectQuery = "SELECT * FROM list"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing selectValue(): v1 \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return arr
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            
            let content = String(cString: sqlite3_column_text(createTablePtr, 0))
            let score = sqlite3_column_int(createTablePtr, 1)
            let confirm = sqlite3_column_int(createTablePtr, 2)
            let position = sqlite3_column_int(createTablePtr, 3)
            
            var st: PreventionList = PreventionList()
            
            st.content = content
            st.score = Int(score)
            st.confirm = Int(confirm)
            st.position = Int(position)
            
            arr.append(st)
        }
        
        sqlite3_finalize(createTablePtr)
        
        print("sql: \(arr)")
        
        return arr
    }
    
    func getVersionSelectValue() -> String {
        print("sqL - getVersionSelectValue() called")
        
        var createTablePtr: OpaquePointer? = nil
        var vs: String = ""
        let selectQuery = "SELECT version FROM onlyversion"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getversionselectValue(): v1 \(errMsg)")
            return "fail"
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            vs = String(cString: sqlite3_column_text(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return vs
    }
    
    func getVersion2SelectValue() -> String {
        print("sqL - getVersion2SelectValue() called")
        
        var createTablePtr: OpaquePointer? = nil
        var vs2: String = ""
        let selectQuery = "SELECT version FROM onlyversion2"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getversion2selectValue(): v1 \(errMsg)")
            return "fail"
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            vs2 = String(cString: sqlite3_column_text(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return vs2
    }
    
    func getAutoLoginSelectValue() -> String {
        print("sqL - getAutoLoginSelectValue() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        var auto: String = ""
        let selectQuery = "SELECT autologin FROM user"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getAutoSelectValue(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return "실패!"
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            auto = String(cString: sqlite3_column_text(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return auto
    }
    
    func getListSelecValue() -> Bool {
        print("sqL - getListSelecValue() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        let selectQuery = "SELECT content FROM list"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getListSelecValue(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return false
        }
        sqlite3_finalize(createTablePtr)
        return true
    }
    
    func initlist() {
        print("sqL - initlist() called")
        
        let deleteQeury3 = "DROP TABLE list"
        
        var createTablePtr : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, deleteQeury3, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("Delete Table SuccessFully \(String(describing: db))")
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Delete Table step fail ! : \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n delete Table prepare fail! : \(errorMessage)")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    func logout(){
        print("sqL - delete() called")
        
        let deleteQeury = "DROP TABLE user"
        
        var createTablePtr : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, deleteQeury, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("Delete Table SuccessFully \(String(describing: db))")
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Delete Table step fail ! : \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n delete Table prepare fail! : \(errorMessage)")
            
        }
    }
    
    func delete() {
        print("sqL - delete() called")
        
        let deleteQeury = "DROP TABLE user"
        let deleteQeury3 = "DROP TABLE list"
        
        var createTablePtr : OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, deleteQeury, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("Delete Table SuccessFully \(String(describing: db))")
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Delete Table step fail ! : \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n delete Table prepare fail! : \(errorMessage)")
            
        }
        
        if sqlite3_prepare_v2(self.db, deleteQeury3, -1, &createTablePtr, nil) == SQLITE_OK {
            if sqlite3_step(createTablePtr) == SQLITE_DONE {
                print("Delete Table SuccessFully \(String(describing: db))")
            }
            else {
                let errorMessage = String(cString: sqlite3_errmsg(db))
                print("\n Delete Table step fail ! : \(errorMessage)")
            }
        }
        else {
            let errorMessage = String(cString: sqlite3_errmsg(db))
            print("\n delete Table prepare fail! : \(errorMessage)")
        }
        
        sqlite3_finalize(createTablePtr)
    }
    
    // firebase를 이용하여 사용자의 정보 가져오기
    func firebaseData(completion: @escaping ((String, String, Int, String, Int) -> Void)) {
        print("sqL - firebaseData() called")
        
        ref3 = Database.database().reference()
        uid = Auth.auth().currentUser!.uid
        
        ref3.child("User").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.email = value?["Email"] as? String ?? ""
            self.nickName = value?["NinName"] as? String ?? ""
            self.score = value?["Score"] as? Int ?? 0
            self.date = value?["Date"] as? String ?? ""
            self.cnt = value?["Cnt"] as? Int ?? 0
            
            completion(self.email, self.nickName, self.score, self.date, self.cnt)
        })
    }
    
    // firebase에서 닉네임 가져오기
    func getNickName() -> String {
        print("sqL - getNickName() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        var nick: String = ""
        let selectQuery = "SELECT nickname FROM user"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getAutoSelectValue(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return "닉네임 불러오기 실패!"
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            nick = String(cString: sqlite3_column_text(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return nick
    }
    
    func updateDate(_ date: String) {
        var createTablePtr: OpaquePointer? = nil
        
        let UpdateQuery = "UPDATE user SET date = ?"
        
        let SQLITE_TRANSIENT = unsafeBitCast(-1, to: sqlite3_destructor_type.self)

        
        if sqlite3_prepare(db, UpdateQuery, -1, &createTablePtr, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: v1\(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_text(createTablePtr, 1, date, -1, SQLITE_TRANSIENT) != SQLITE_OK{
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }

        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("update fail :: \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
        
    }
    func getCnt() -> Int {
        var createTablePtr: OpaquePointer? = nil
        
        var cnt: Int = 0
        let selectQuery = "SELECT cnt from user"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getAutoSelectValue(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return 0
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            cnt = Int(sqlite3_column_int(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return cnt
    }
    
    func updateCnt(_ cnt: Int) {
        print("sqL - updateCnt() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        let UpdateQuery = "UPDATE user SET cnt = ?"
        
        if sqlite3_prepare(db, UpdateQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: v1\(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 1, Int32(cnt)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("update fail :: \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
    }
    
    func updateScore(_ score: Int) {
        print("sqL - updateScore() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        let UpdateQuery = "UPDATE user SET score = ?"
        
        if sqlite3_prepare(db, UpdateQuery, -1, &createTablePtr, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: v1\(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 1, Int32(score)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("update fail :: \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)
        
    }
    
    func updateConfirm(_ position:Int) {
        print("sqL - updateConfirmr() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        let UpdateQuery = "UPDATE list SET confirm = 1 where positions = ?"
        
        if sqlite3_prepare(db, UpdateQuery, -1, &createTablePtr, nil) != SQLITE_OK{
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing update: v1\(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_bind_int(createTablePtr, 1, Int32(position)) != SQLITE_OK {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("failture binding name: \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return
        }
        
        if sqlite3_step(createTablePtr) != SQLITE_DONE {
            let errMsg = String(cString : sqlite3_errmsg(db)!)
            print("update fail :: \(errMsg)")
            
            sqlite3_finalize(createTablePtr)
            return
        }
        
        sqlite3_finalize(createTablePtr)

    }
    
    // firebase에서 스코어 가져오기
    func getScore() -> Int {
        print("sqL - getNickName() called")
        
        var createTablePtr: OpaquePointer? = nil
                
        var score: Int = 0
        let selectQuery = "SELECT score FROM user"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getAutoSelectValue(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return 0
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            score = Int(sqlite3_column_int(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return score
    }
    
    func getEmail() -> String {
        print("sqL - getEmail() called")
        
        var createTablePtr: OpaquePointer? = nil
        
        var email: String = ""
        let selectQuery = "SELECT email FROM user"
        
        if sqlite3_prepare(self.db, selectQuery, -1, &createTablePtr, nil) != SQLITE_OK {
            let errMsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing getAutoSelectValue(): v1 \(errMsg)")
            sqlite3_finalize(createTablePtr)
            return "email 불러오기 실패!"
        }
        
        while(sqlite3_step(createTablePtr) == SQLITE_ROW) {
            email = String(cString: sqlite3_column_text(createTablePtr, 0))
        }
        
        sqlite3_finalize(createTablePtr)
        return email
    }
    
}
