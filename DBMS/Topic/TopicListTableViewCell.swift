import UIKit

class TopicListTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTopicNumber: UILabel!
    @IBOutlet weak var lblTopicName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
