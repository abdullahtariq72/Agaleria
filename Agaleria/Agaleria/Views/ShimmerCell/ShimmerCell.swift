//
//  ShimmerCell.swift
//  Agaleria
//
//  Created by Abdullah Tariq on 04/06/2022.
//

import UIKit

class ShimmerCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.startShimmeringViewAnimation()
    }
}
