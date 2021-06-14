//
//  LoaderVC.swift
//  RedMadRobotTestTask
//
//  Created by Дмитрий Марченков on 18.05.2021.
//

import UIKit

/// Экран сигнализирующий начало долгой загрузки
final class LoaderVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var loaderIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var backgroundView: UIView!
    
    // MARK: - Public Properties
    
    public var stopLoad: (() -> Void)?
    
    // MARK: - Life cycle
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showDownload()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loaderIndicator.alpha = 0.0
    }
    
    // MARK: - IBAction
    
    /// При тапе на экран сообщаем об остановки загрузки
    @IBAction private func tapGesture(_ sender: Any) {
        stopLoad?()
    }
    
    // MARK: - Private Methods
    
    private func showDownload() {
        loaderIndicator.startAnimating()
        
        UIView.animate(withDuration: 0.3) {
            self.backgroundView.alpha = 0.3
            self.loaderIndicator.alpha = 1.0
        }

    }
    
}
