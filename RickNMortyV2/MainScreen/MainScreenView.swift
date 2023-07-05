//
//  MainScreenView.swift
//  RickNMortyV2
//
//  Created by Дмитрий Болучевских
//

import SwiftUI
import RickNMortyAPI
import SDWebImageSwiftUI
import UIComponents

public enum NavigationStackPath: Hashable {
    case characterCard(Character)

    public static func == (lhs: NavigationStackPath, rhs: NavigationStackPath) -> Bool {
        return lhs.getId() == rhs.getId()
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(getId())
    }

    private func getId() -> String {
        switch self {
        case .characterCard: return "characterCard"
        }
    }
}

struct MainScreenView: View {
    @ObservedObject var viewModel = MainScreenViewModel(repository: MainScreenRepository())
    @ObservedObject var cardViewModel = CharacterCardViewModel()
    @State var navigationPath: [NavigationStackPath] = []
    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible()),
    ]

    private let placeholderSize: CGFloat = (UIScreen.main.bounds.width - 36) / 2

    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView(.vertical, showsIndicators: false) {
                Section(
                    content: ContentView,
                    footer: LoadingPlaceholderView
                )
                .padding(.horizontal, 12)
            }
            .padding(.top)
            .navigationDestination(for: NavigationStackPath.self, destination: navigateToScreen)
        }
    }

    @ViewBuilder
    private func navigateToScreen(with option: NavigationStackPath) -> some View {
        switch option {
        case let .characterCard(character):
            CharacterCardView(character: character, viewModel: cardViewModel)
        }
    }

    @ViewBuilder
    private func ContentView() -> some View {
        LazyVGrid(columns: columns, spacing: 12) {
            ForEach(viewModel.characters, id: \.self) { character in
                CatalogCharacterCardView(character: character, onTapAction: onCardTapAction)
            }
        }
    }

    @ViewBuilder
    private func LoadingPlaceholderView() -> some View {
        GeometryReader { reader in
            if reader.frame(in: .global).maxY <= UIScreen.main.bounds.height + 200, viewModel.isNextPageExist {
                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(0..<6, id: \.self, content: PlaceholderCardView)
                }
                .onAppear(perform: viewModel.nextPage)
            }
        }
    }

    @ViewBuilder
    private func PlaceholderCardView(_: Int) -> some View {
        VStack(spacing: 12) {
            ShimmerView()
                .frame(width: placeholderSize, height: placeholderSize)

            ShimmerView()
                .frame(width: placeholderSize, height: 40)
        }
        .padding(.horizontal, 12)
    }

    private func onCardTapAction(_ character: Character) {
        cardViewModel.character = character
        cardViewModel.isLoading = true
        navigationPath.append(.characterCard(character))
    }
}

struct MainScreenView_Previews: PreviewProvider {
    static var previews: some View {
        MainScreenView()
    }
}
