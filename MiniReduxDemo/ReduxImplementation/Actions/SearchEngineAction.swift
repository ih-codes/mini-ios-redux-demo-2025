// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

struct SearchEnginesAction: Action {
    let windowUUID: WindowUUID
    let actionType: SearchEnginesActionType
}

enum LoadSearchEnginesError: Error, Codable {
    case timedOut
    case emptyResults
}

public protocol SearchEnginesActionType: ActionType {}

enum SearchEnginesUserActionType: SearchEnginesActionType {
    case didTapLoadEnginesButton
    case didToggleBackgroundColor
}

enum SearchEnginesMiddlewareActionType: SearchEnginesActionType {
    case didLoadSearchEngines(Result<[SearchEngineModel], LoadSearchEnginesError>)
}
