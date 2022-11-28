//
//  ViewController.swift
//  Rx+MVVM_Practice
//
//  Created by Jihee hwang on 2022/11/28.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

struct Model {
    var number: Int
}

final class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 30)
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .gray
        return button
    }()
    
    var disposeBag = DisposeBag()
    var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        layout()
        self.bind(viewModel: self.viewModel)
    }
    
    private func bind(viewModel: ViewModel) {
        self.viewModel.number
            .drive(label.rx.text)
            .disposed(by: self.disposeBag)
        
        self.button.rx.tap
            .bind(to: viewModel.tap)
            .disposed(by: self.disposeBag)
      }

    private func layout() {
        view.addSubview(label)
        view.addSubview(button)
        
        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(50)
        }
        
        button.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(30)
        }
    }
}

