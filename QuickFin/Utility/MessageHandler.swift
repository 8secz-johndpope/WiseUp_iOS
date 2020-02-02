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

class MessageHandler {
    
    static var shared = MessageHandler()
    private init() {}
    weak var gameDelegate: GameDelegate?
    
    private func getView(theme: Theme, title: String, body: String, buttonTitle: String? = nil) -> MessageView {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureTheme(theme)
        errorView.configureDropShadow()
        errorView.configureContent(title: title.localized(), body: body.localized())
        if let buttonTitle = buttonTitle {
            errorView.button?.setTitle(buttonTitle.localized(), for: .normal)
        } else {
            errorView.button?.setTitle(Text.Okay.localized(), for: .normal)
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
        view.configureContent(title: Text.Insights.localized(), body: body.localized())
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: FontSizes.insightsTitle)
        view.button?.setTitle(Text.Next.localized(), for: .normal)
        _ = view.button?.reactive.tap.observeNext(with: { [unowned self] (_) in
            SwiftMessages.hide()
            self.gameDelegate?.proceedToNextVC()
        })
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.duration = .forever
        
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: 20)
        
        config.interactiveHide = false
        SwiftMessages.show(config: config, view: view)
    }
    
    func showActiveItem(body: String) {
        let view = MessageView.viewFromNib(layout: .tabView)
        view.configureTheme(.success)
        view.configureDropShadow()
        view.configureContent(title: Text.ActiveItem.localized(), body: body.localized())
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: FontSizes.insightsTitle)
        view.button?.setTitle(Text.Hide.localized(), for: .normal)
        _ = view.button?.reactive.tap.observeNext(with: { (_) in
            SwiftMessages.hide()
        })
        var config = SwiftMessages.Config()
        config.presentationStyle = .bottom
        config.duration = .forever
        
        view.layoutMarginAdditions = UIEdgeInsets(top: 20, left: 20, bottom: 50, right: 20)
        
        config.interactiveHide = false
        SwiftMessages.show(config: config, view: view)
    }
    
    func showGenericWarningMessage(function: @escaping () -> Void) {
        let warningView = MessageView.viewFromNib(layout: .cardView)
        warningView.configureTheme(Theme.warning)
        warningView.configureDropShadow()
        warningView.configureContent(title: Text.Warning.localized(), body: Text.GenericWarning.localized())
        warningView.button?.setTitle(Text.Yes.localized(), for: .normal)
        _ = warningView.button?.reactive.tap.observeNext(with: { (_) in
            function()
            SwiftMessages.hide()
        })
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .statusBar)
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: warningView)
    }
    
}
