import UIKit

class type2TableViewCell: UITableViewCell {
    
    //MARK: - IBOutlet
    @IBOutlet weak var txtLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
