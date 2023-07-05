//
//  CharacterCardViewModel.swift
//  
//
//  Created by Дмитрий Болучевских
//

import Combine
import DataLayer
import Foundation
import RickNMortyAPI

public class CharacterCardViewModel: ObservableObject {
    @Published public var character: Character?
    @Published public var episodes: [Episode] = []
    @Published public var isLoading: Bool = true

    private var cancellables: Set<AnyCancellable> = []

    public init() {
        subscribe()
    }

    private func subscribe() {
        $character
            .debounce(for: .seconds(1.5), scheduler: DispatchQueue.main)
            .sink { [weak self] character in
                guard let self, let character else { return }
                Task {
                    await self.getEpisodesInfo(episodeUrls: character.episode)
                }
            }
            .store(in: &cancellables)
    }

    private func getEpisodeAsync(by url: String) async -> Episode? {
        do {
            let episode = try await CharacterScreenService().getEpisodeInfo(by: url)
            return episode
        } catch {
            print("error: \(error)")
            return nil
        }
    }

    private func getEpisodesInfo(episodeUrls: [String]) async {
        await MainActor.run {
            self.isLoading = true
        }

        let episodes: [Episode] = await withTaskGroup(of: Episode?.self) { group in
            for index in 0..<episodeUrls.count {
                group.addTask {
                    let episode: Episode? = await self.getEpisodeAsync(by: episodeUrls[index])
                    return episode
                }
            }

            return await group.reduce(into: [Episode]()) { allEpisodes, episode in
                guard let episode else { return }
                allEpisodes.append(episode)
            }
        }

        await MainActor.run {
            self.episodes = episodes.sorted { $0.id < $1.id }
            self.isLoading = false
        }
    }
}
