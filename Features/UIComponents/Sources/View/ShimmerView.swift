//
//  ShimmerView.swift
//  
//
//  Created by Дмитрий Болучевских
//

import SwiftUI

public struct ShimmerView: View {
    @State private var isAnimated = false
    let mainColor: Color
    let highlightColor: Color
    let isLeanedBackward: Bool

    public init(
        mainColor: Color = .black.opacity(0.05),
        highlightColor: Color = .white,
        isLeanedBackward: Bool = false
    ) {
        self.mainColor = mainColor
        self.highlightColor = highlightColor
        self.isLeanedBackward = isLeanedBackward
    }

    public var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                mainColor
                    .cornerRadius(4)

                highlightColor
                    .cornerRadius(4)
                    .mask(
                        Rectangle()
                            .fill(
                                LinearGradient(colors: [.clear, highlightColor.opacity(0.48), .clear], startPoint: .top, endPoint: .bottom)
                            )
                            .frame(width: geometryProxy.size.height + 90, height: 250)
                            .rotationEffect(.init(degrees: isLeanedBackward ? 80 : -80))
                            .offset(x: isAnimated ? geometryProxy.size.width / 2 + 130 : -geometryProxy.size.width / 2 - 130)
                    )
            }
            .frame(maxWidth: .infinity)
            .onAppear(perform: setAnimated)
        }
    }

    private func setAnimated() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.default.speed(0.3).delay(0.7).repeatForever(autoreverses: false)) {
                isAnimated.toggle()
            }
        }
    }
}

struct ShimmerView_Previews: PreviewProvider {
    static var previews: some View {
        ShimmerView()
            .previewLayout(.sizeThatFits)
            .frame(height: 500)
            .padding()
    }
}
