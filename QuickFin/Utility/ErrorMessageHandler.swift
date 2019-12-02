//
//  ErrorMessageHandler.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/18/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SwiftMessages
import Localize_Swift

class ErrorMessageHandler {
    
    static var shared = ErrorMessageHandler()
    private init() {}
    weak var gameDelegate: GameDelegate?
    
    private func getView(theme: Theme, title: String, body: String, buttonTitle: String? = nil) -> MessageView {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureTheme(theme)
        errorView.configureDropShadow()
        errorView.configureContent(title: title.localized(), body: body)  // Error messages are typically pre-localized
        if let buttonTitle = buttonTitle {
            errorView.button?.setTitle(buttonTitle.localized(), for: .normal)
        } else {
            errorView.button?.setTitle("Okay".localized(), for: .normal)
        }
        _ = errorView.button?.reactive.tap.observeNext(with: { (_) in
            SwiftMessages.hide()
        })
        return errorView
    }
    
    func showMessage(theme: Theme, title: String, body: String, buttonTitle: String? = nil) {
        let errorView = getView(theme: theme, title: title, body: body, buttonTitle: buttonTitle)
        SwiftMessages.show(view: errorView)
    }
    
    func showMessageModal(theme: Theme, title: String, body: String, buttonTitle: String? = nil) {
        let errorView = getView(theme: theme, title: title, body: body, buttonTitle: buttonTitle)
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .statusBar)
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: errorView)
    }
    
    func showMessageOnCorrectChoice(body: String) {
        let view = MessageView.viewFromNib(layout: .tabView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(title: "Insights\n".localized(), body: body.localized())
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: FontSizes.insightsTitle)
        view.button?.setTitle("Next".localized(), for: .normal)
        _ = view.button?.reactive.tap.observeNext(with: { [unowned self] (_) in
            SwiftMessages.hide()
            self.gameDelegate?.proceedToNextVC()
        })
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.duration = .forever
        SwiftMessages.show(config: config, view: view)
    }
    
}
