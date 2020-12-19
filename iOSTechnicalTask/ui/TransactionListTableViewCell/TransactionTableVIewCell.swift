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
    
    override var isSelected: Bool {
        didSet {
            viewSelectionOverlay.isHidden = !isSelected
        }
    }
    
    private let disposeBag = DisposeBag()
    
    var viewModel : TransactionTableViewCellModel! {
        didSet {
            bindViewModel()
        }
    }
    
    private func bindViewModel() {
        
        viewModel.imagePath
            .subscribe( onNext: { [weak self] (imagePath) in
                guard let self = self else { return }
                
                let url = URL(string: imagePath)
                self.ivIcon.kf.setImage(with: url)
            })
            .disposed(by: disposeBag)
        
        viewModel.description.bind(to: lblTitle.rx.text).disposed(by: disposeBag)
        viewModel.category.bind(to: lblSubTitle.rx.text).disposed(by: disposeBag)
        Observable.zip(viewModel.amount, viewModel.currency).subscribe { [weak self] (amount, currency) in
            guard let self = self else { return }
            
            self.lblPrice.text = String(format: "%@%@", currency, amount)
        }
        .disposed(by: disposeBag)

    }
}
