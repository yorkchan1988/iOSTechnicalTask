//
//  TransactionListTableVIewCell.swift
//  iOSTechnicalTask
//
//  Created by YORK CHAN on 13/12/2020.
//

import Foundation
import UIKit
import RxSwift
import Kingfisher

class TransactionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ivIcon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var viewSelectionOverlay: UIView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel : TransactionTableViewCellViewModel! {
        didSet {
            configureImageView()
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        
        viewModel.imagePath
            .subscribe( onNext: { [ivIcon] (imagePath) in
                
                let url = URL(string: imagePath)
                ivIcon?.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.description.bind(to: lblTitle.rx.text).disposed(by: disposeBag)
        viewModel.category.bind(to: lblSubTitle.rx.text).disposed(by: disposeBag)
        
        // display value in lblPrice only when amount and currency are both ready
        Observable.zip(viewModel.amount, viewModel.currency).subscribe { [lblPrice] (amount, currency) in
            
            lblPrice?.text = String(format: "%@%@", currency, amount)
        }
        .disposed(by: disposeBag)

        viewModel.isSelected.subscribe(
            onNext: { [viewSelectionOverlay] (isSelected) in
                viewSelectionOverlay?.isHidden = !isSelected
            }
        )
        .disposed(by: disposeBag)
    }
    
    private func configureImageView() {
        ivIcon.layer.cornerRadius = ivIcon.bounds.width / 2.0
        ivIcon.layer.borderWidth = 2.0
        ivIcon.layer.borderColor = AppColor.borderLightGrey.cgColor
    }
}
