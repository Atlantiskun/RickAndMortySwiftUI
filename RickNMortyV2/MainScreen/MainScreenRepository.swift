//
//  MainScreenRepository.swift
//  RickNMortyV2
//
//  Created by Дмитрий Болучевских
//

import Combine
import DataLayer
import Foundation
import RickNMortyAPI

class MainScreenRepository: MainScreenRepositoryProtocol {
    private var service: MainScreenService
    private var cancellables: Set<AnyCancellable> = []

    @Published private var characters: [Character] = []
    var charactersSignal: Published<[Character]>.Publisher { $characters }
    @Published private var currentPage: Int = 1
    var currentPageSignal: Published<Int>.Publisher { $currentPage }
    @Published private var isNextPageExist: Bool = false
    var isNextPageExistSignal: Published<Bool>.Publisher { $isNextPageExist }

    init() {
        self.service = MainScreenService()
    }

    func getAllCharacters(from page: Int) async {
        do {
            try await service.getAllCharacters(from: page)
            characters = service.characters
            isNextPageExist = service.isNextPageExist
        } catch {
            print(error)
        }
    }

    func nextPage() async {
        do {
            try await service.nextPage()
            characters = service.characters
            isNextPageExist = service.isNextPageExist
        } catch {
            print(error)
        }
    }
}
