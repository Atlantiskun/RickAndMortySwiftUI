//
//  MainScreenViewModel.swift
//  RickNMortyV2
//
//  Created by Дмитрий Болучевских
//

import Combine
import Foundation
import RickNMortyAPI

protocol MainScreenRepositoryProtocol {
    var charactersSignal: Published<[Character]>.Publisher { get }
    var currentPageSignal: Published<Int>.Publisher { get }
    var isNextPageExistSignal: Published<Bool>.Publisher { get }

    func getAllCharacters(from page: Int) async
    func nextPage() async
}

class MainScreenViewModel: ObservableObject {
    private var repository: MainScreenRepositoryProtocol
    private var cancellables: Set<AnyCancellable> = []
    @Published var characters: [Character] = []
    @Published var isNextPageExist: Bool = false

    init(repository: MainScreenRepositoryProtocol) {
        self.repository = repository
        Task {
            await repository.getAllCharacters(from: 1)
        }

        subscribe()
    }

    private func subscribe() {
        repository.charactersSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] characters in
                guard let self else { return }
                self.characters = characters
            }
            .store(in: &cancellables)

        repository.isNextPageExistSignal
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isNextPageExist in
                guard let self else { return }
                self.isNextPageExist = isNextPageExist
            }
            .store(in: &cancellables)
    }

    func nextPage() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            Task { [weak self] in
                guard let self else { return }
                await self.repository.nextPage()
            }
        }
    }
}
