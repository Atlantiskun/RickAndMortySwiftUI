//
//  CharacterCardView.swift
//  
//
//  Created by Дмитрий Болучевских
//

import RickNMortyAPI
import SwiftUI
import SDWebImageSwiftUI

public struct CharacterCardView: View {
    @ObservedObject var viewModel: CharacterCardViewModel
    @State var character: Character

    public init(
        character: Character,
        viewModel: CharacterCardViewModel
    ) {
        _character = State(initialValue: character)
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    public var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: 20) {
                VStack(spacing: 12) {
                    WebImage(url: URL(string: character.image))
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .padding(.horizontal, 40)

                    Text(character.name)
                        .font(.largeTitle)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Episodes")
                        .font(.system(size: 22))
                    if viewModel.isLoading {
                        ForEach(0..<min(6, character.episode.count), id: \.self, content: PlaceholderView)
                    } else {
                        ForEach(viewModel.episodes, id: \.self) { episode in
                            Text("\(episode.episode): \(episode.name)")
                                .font(.system(size: 16))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    @ViewBuilder
    private func PlaceholderView(_: Int) -> some View {
        ShimmerView()
            .frame(width: UIScreen.main.bounds.width - 32, height: 40)
    }
}

struct CharacterCardView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCardView(character: Character(), viewModel: CharacterCardViewModel())
    }
}
