// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

enum LoadSearchEnginesError: Error, Codable {
    case timedOut
    case emptyResults
}

struct SearchEnginesAction: Action {
    let windowUUID: WindowUUID
    let actionType: ActionType
    let loadEnginesResult: Result<[SearchEngineModel], LoadSearchEnginesError>?

    init(
        windowUUID: WindowUUID,
        actionType: ActionType,
        loadEnginesResult: Result<[SearchEngineModel], LoadSearchEnginesError>? = nil
    ) {
        self.windowUUID = windowUUID
        self.actionType = actionType
        self.loadEnginesResult = loadEnginesResult
    }
}

enum SearchEnginesActionType: ActionType {
    case didTapLoadEnginesButton
}

enum SearchEnginesMiddlewareActionType: ActionType {
    case didLoadSearchEngines
}
