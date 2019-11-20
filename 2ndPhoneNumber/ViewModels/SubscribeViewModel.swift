//
//  SubscribeViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 20.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import UIKit

class SubscribeViewModel {
    private let TERMS_OF_USE = "https://google.com"
    private let PRIVACY_POLICY = "https://google.com"

    func getTermsOfUseURL() -> URL {
        return URL(string: TERMS_OF_USE)!
    }

    func getPrivacyPolicyURL() -> URL {
        return URL(string: PRIVACY_POLICY)!
    }

    func performSubscription() {

    }

    func restoreSubscription() {

    }


}
