//
//  RecentCallsViewModel.swift
//  2ndPhoneNumber
//
//  Created by Елизар Кондрашов on 27.11.2019.
//  Copyright © 2019 Елизар Кондрашов. All rights reserved.
//

import Foundation

class RecentCallsViewModel {
    var accountViewModel: AccountViewModel
    var isFiltered = false

    init(accountViewModel: AccountViewModel) {
        self.accountViewModel = accountViewModel
    }

    func getRecentCellDataList() -> [RecentCellData] {
        var list = accountViewModel.recentsCellDataList

        if isFiltered {
            list = list.filter{ (recentCellData: RecentCellData) -> Bool in
                return recentCellData.call.status == .MISSED
            }
        }
        return list
    }
}
