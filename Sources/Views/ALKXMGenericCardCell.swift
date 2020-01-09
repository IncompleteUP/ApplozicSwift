//
//  ALKXMGenericCardCell.swift
//  ApplozicSwift
//
//  Created by Incomplete on 2020/1/9.
//  Copyright © 2020 Applozic. All rights reserved.
//

import UIKit

class ALKXMGenericCardCell: UICollectionViewCell {
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var lb_name: UILabel!
    @IBOutlet weak var lb_orderNumber: UILabel!
    @IBOutlet weak var lb_price: UILabel!
    @IBOutlet weak var lb_subPrice: UILabel!
    @IBOutlet weak var img_product: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
