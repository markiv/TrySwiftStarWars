//
//  ListDetailItem.swift
//  StarWars
//
//  Created by Vikram Kriplaney on 13.09.22.
//

import SwiftUI

struct ListDetailItem: View {
    let label: LocalizedStringKey
    let value: CustomStringConvertible?

    var body: some View {
        if let value = value {
            HStack {
                Text(label).foregroundColor(.secondary)
                Spacer()
                Text(String(describing: value))
                    .multilineTextAlignment(.trailing)
            }
        }
    }
}

#if DEBUG
struct ListDetailItem_Previews: PreviewProvider {
    static var previews: some View {
        List {
            ListDetailItem(label: "Hello", value: "World")
            ListDetailItem(label: "Number", value: 42)
            ListDetailItem(label: "Date", value: Date.now)
            ListDetailItem(label: "Nil", value: nil)
        }
    }
}
#endif
