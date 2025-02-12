//
//  BookTableViewCell.swift
//  FavBook
//
//  Created by Şakir Yılmaz ÖĞÜT on 12.02.2025.
//

import UIKit
import SDWebImage

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with book: Book) {
        titleLabel.text = book.title
        authorLabel.text = book.author
        categoryLabel.text = book.category
        
        // Configure status label
        statusLabel.text = book.readingStatus
        switch book.readingStatus {
        case "Reading":
            statusLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
            statusLabel.textColor = .systemBlue
        case "ToRead":
            statusLabel.backgroundColor = UIColor.systemOrange.withAlphaComponent(0.1)
            statusLabel.textColor = .systemOrange
        case "Completed":
            statusLabel.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.1)
            statusLabel.textColor = .systemGreen
        default:
            statusLabel.backgroundColor = UIColor.systemGray.withAlphaComponent(0.1)
            statusLabel.textColor = .systemGray
        }
        
        // Load image if available
        if let imageURLString = book.imageURL,
           let imageURL = URL(string: imageURLString) {
            bookImageView.sd_setImage(
                with: imageURL,
                placeholderImage: UIImage(systemName: "book.fill"),
                options: .continueInBackground,
                completed: nil
            )
        } else {
            bookImageView.image = UIImage(systemName: "book.fill")
            bookImageView.tintColor = .systemGray4
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
