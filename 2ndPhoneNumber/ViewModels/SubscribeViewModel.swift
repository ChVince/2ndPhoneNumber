//
//  SubscribeViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 20.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

class SubscribeViewModel {
    private let TERMS_OF_USE: Service = Services.TERMS_OF_USE
    private let PRIVACY_POLICY: Service = Services.PRIVACY_POLICY
    private let POST_SUBSCRIPTION_SUBSCRIBE: Service = Services.POST_SUBSCRIPTION_SUBSCRIBE
    private let POST_SUBSCRIPTION_RESTORE: Service = Services.POST_SUBSCRIPTION_RESTORE

    func getTermsOfUseURL() -> URL {
        return TERMS_OF_USE.url
    }

    func getPrivacyPolicyURL() -> URL {
        return PRIVACY_POLICY.url
    }

    //### Not Implemented
    func performSubscription(completion: @escaping () -> Void) {
        completion()
        /*
        DataManager.fetchData(url: POST_SUBSCRIPTION_SUBSCRIBE.url) { [weak self] (data) in
            completion()
        }*/
    }

    //### Not Implemented
    func restoreSubscription(completion: @escaping () -> Void) {
        completion()
        /*
        DataManager.fetchData(url: POST_SUBSCRIPTION_RESTORE.url) { [weak self] (data) in
            completion()
        }*/
    }


}
