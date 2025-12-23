// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Foundation

struct ScreenAction: Action {
    let windowUUID: WindowUUID
    let actionType: ActionType
    let screen: AppScreen
}

enum AppScreen {
    case searchEngines
}

enum ScreenActionType: ActionType {
    case showScreen
    case closeScreen
}
