//
//  HomeView.swift
//  TechnicalAssignment
//
//  Created by Jamie on 09/04/2025.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel: ViewModel
    @State private var scrollViewHeight = CGFloat.infinity
    @State private var scrollViewTotalSize: CGSize = .zero
    @State private var scrollViewSize: CGSize = .zero
    @State private var visibilityPlayerIndexs: Set<String> = []
    @State private var mainPlayerContainerView: PlayerContainerView = .init(playerView: .init())
    
    fileprivate let isIPhone = Device.isIPhone
    private let padding: CGFloat = 5
    private let spaceName = "scrollView"
    private let screenWidth = Device.screenWidth
    
    private var columns: Int {
        return isIPhone ? 2 : 3
    }
    private var mainVideoContentViewHeight: CGFloat {
        return isIPhone ? screenWidth - 100 : (screenWidth - 2 * padding) / 2.5
    }
    private var totalOfSpacing: CGFloat {
        return padding * (CGFloat(columns) - 1)
    }
    private var itemWidth: CGFloat {
        return (screenWidth - totalOfSpacing) / CGFloat(columns)
    }
    
    var body: some View {
        VStack {
            if viewModel.output.isFetchingAdvertisements {
                ProgressView(Strings.loading.capitalized)
            } else {
                mainView()
            }
        }.onAppear {
            viewModel.transform(.fetchAdvertisements)
            viewModel.transform(.fetchCurrentProducts)
        }
    }
    
    private func mainView() -> some View {
        VStack {
            SizeReaderView(size: $scrollViewTotalSize) {
                VisibilityTrackingListView(action: handleVisibilityChanged) {
                    SizeReaderView(size: $scrollViewSize) {
                        VStack {
                            ZStack(alignment: .top) {
                                ScrollViewOffsetTracker()
                                LazyVStack(spacing: padding) {
                                    if viewModel.output.data.count > 0 {
                                        itemsView(items: viewModel.output.data)
                                    }
                                    if !viewModel.output.isLoadedNextPage {
                                        ProgressView()
                                            .frame(height: 100)
                                    }
                                }
                            }
                        }
                        .background(
                            GeometryReader { proxy in
                                Color.clear.preference(key: OffsetPreferenceKey.self,
                                                       value: -1 * proxy.frame(in: .named(spaceName)).origin.y)
                            }
                        )
                        .onPreferenceChange(
                            OffsetPreferenceKey.self,
                            perform: { value in
                                let reachEnd = value >= scrollViewSize.height - scrollViewTotalSize.height - 50
                                guard reachEnd else { return }
                                viewModel.transform(.fetchNextProducts)
                            }
                        )
                    }
                }
                .coordinateSpace(name: spaceName)
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .background(Color.white)
                .refreshable {
                    guard !viewModel.output.isLoadedPreviousPage else { return }
                    viewModel.transform(.fetchPreviousProducts)
                }.onChange(of: viewModel.output.isLoadedPreviousPage) {
                    guard let firstItem = viewModel.output.data.first as? Product,
                          firstItem.type == .video,
                          let videoUrlString = firstItem.videoUrl,
                          let videoUrl = URL(string: videoUrlString) else { return }
                    mainPlayerContainerView.prepareVideo(videoUrl)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        mainPlayerContainerView.play()
                    }
                }
            }
        }
        .padding(.top, padding)
        .padding(.leading, isIPhone ? -10 : padding)
        .padding(.trailing, isIPhone ? -10 : padding)
        .padding(.bottom, padding)
    }
    
    private func handleVisibilityChanged(_ id: String, change: VisibilityChange, tracker: VisibilityTracker<String>) {
        DispatchQueue.main.async {
            switch change {
            case .shown:
                visibilityPlayerIndexs.insert(id)
                break
            case .hidden:
                visibilityPlayerIndexs.remove(id)
                break
            }
        }
    }
}

extension HomeView {
    
    private func itemsView(items: [Any]) -> some View {
        VStack(spacing: padding) {
            let itemsWithoutMainVideo = Array(items.dropFirst())
            if let firstItem = items.first as? Product,
               firstItem.type == .video,
               let videoUrlString = firstItem.videoUrl,
               let videoUrl = URL(string: videoUrlString) {
                VStack {
                    let isHiddenFromContentView = Binding<Bool>(get: {
                        return !visibilityPlayerIndexs.contains("0")
                    }, set: { _,_ in })
                    mainPlayerContainerView.frame(height: mainVideoContentViewHeight)
                        .background(content: {
                            Rectangle()
                                .fill(Color.random())
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: mainVideoContentViewHeight)
                        })
                        .trackVisibility(id: "0")
                        .onAppear {
                            mainPlayerContainerView.prepareVideo(videoUrl)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                mainPlayerContainerView.play()
                            }
                        }
                        .onChange(of: isHiddenFromContentView.wrappedValue) {
                            guard isHiddenFromContentView.wrappedValue else {
                                mainPlayerContainerView.play()
                                return
                            }
                            mainPlayerContainerView.pause()
                        }
                }
            }
            MasonryStack(columns: columns, spacing: padding) {
                ForEach(0..<itemsWithoutMainVideo.count, id: \.self) { idx in
                    VStack {
                        if let product = itemsWithoutMainVideo[idx] as? Product {
                            productView(product: product,
                                        idx: idx)
                        } else if let advertisement = itemsWithoutMainVideo[idx] as? Advertisement {
                            advertisementView(advertisement: advertisement,
                                              idx: idx)
                        }
                    }
                }
            }
        }
    }
    
    private func productView(product: Product, idx: Int) -> some View {
        VStack {
            let order = Device.isIPhone ? idx % 4 : idx % 9
            let itemHeight = HomeView.ViewModel.getItemHeight(itemOrder: order,
                                                              itemWidth: itemWidth)
            if product.type == .video,
               let videoUrlString = product.videoUrl,
               let videoUrl = URL(string: videoUrlString) {
                let playerView = PlayerView()
                let playerContainerView = PlayerContainerView(playerView: playerView, url: videoUrl)
                playerContainerView.frame(height: itemHeight)
                    .background(content: {
                        Rectangle()
                            .fill(Color.random())
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: itemHeight)
                    })
                    .clipped()
            } else if let urlString = product.imageUrl,
                      let url = URL(string: urlString) {
                ZStack {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: itemHeight)
                            .clipped()
                    } placeholder: {
                        Rectangle().fill(Color.random())
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: itemHeight)
                    }
                    if let price = product.price, price > 0 {
                        TagView(price: price)
                    }
                }
            }
        }
    }
    
    private func advertisementView(advertisement: Advertisement, idx: Int) -> some View {
        VStack {
            let order = Device.isIPhone ? idx % 4 : idx % 9
            let itemHeight = HomeView.ViewModel.getItemHeight(itemOrder: order,
                                                              itemWidth: itemWidth)
            if let urlString = advertisement.urls?.full,
               let url = URL(string: urlString) {
                ZStack {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: itemHeight)
                            .clipped()
                        
                    } placeholder: {
                        Rectangle().fill(Color.random())
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .frame(height: itemHeight)
                    }
                    VStack {
                        Spacer()
                        HStack {
                            Text(Strings.ads.capitalized)
                                .font(.system(size: (isIPhone ? 12 : 20)))
                                .fontWeight(.semibold)
                                .font(.system(size: 60))
                                .foregroundStyle(Color.white)
                                .padding(isIPhone ? 2 : 4)
                                .background {
                                    Rectangle().fill(Color.yellow.opacity(0.5))
                                }
                            Spacer()
                        }
                    }
                }
            }
            
        }
    }
}

#Preview {
    let homeView = HomeView(viewModel: .init())
    return homeView
}
