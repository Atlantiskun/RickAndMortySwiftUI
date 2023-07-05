//
//  CatalogCharacterCardView.swift
//  
//
//  Created by Дмитрий Болучевских
//

import RickNMortyAPI
import SwiftUI
import SDWebImageSwiftUI

public struct CatalogCharacterCardView: View {
    @State var character: Character
    let onTapAction: (Character) -> Void

    public init(character: Character, onTapAction: @escaping (Character) -> Void) {
        _character = State(initialValue: character)
        self.onTapAction = onTapAction
    }
    
    public var body: some View {
        VStack {
            if let url = URL(string: character.image) {
                WebImage(url: url)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
            } else {
                Rectangle()
                    .foregroundColor(.gray)
            }

            Text(character.name)

            Spacer(minLength: 0)
        }
        .onTapGesture(perform: { onTapAction(character) })
    }
}

struct CatalogCharacterCardView_Previews: PreviewProvider {
    static var previews: some View {
        CatalogCharacterCardView(character: Character(), onTapAction: { _ in })
    }
}
