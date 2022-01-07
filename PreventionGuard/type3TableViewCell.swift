import UIKit

class type3TableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    
}


