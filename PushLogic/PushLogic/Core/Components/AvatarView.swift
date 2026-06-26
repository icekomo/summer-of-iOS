//
//  AvatarView.swift
//  PushLogic
//
//  Generic circular avatar. Renders initials, an SF Symbol, or an image
//  — caller supplies the source.
//

import SwiftUI

struct AvatarView: View {
    enum Source {
        case initials(String)
        case systemImage(String)
        case image(Image)
    }

    let source: Source
    var size: CGFloat = 40
    var backgroundColor: Color = AppColors.primary
    var foregroundColor: Color = AppColors.onPrimary

    var body: some View {
        switch source {
        case .initials(let value):
            Text(value.avatarInitials)
                .font(.system(size: size * 0.4, weight: .semibold, design: .rounded))
                .foregroundStyle(foregroundColor)
                .frame(width: size, height: size)
                .background(Circle().fill(backgroundColor))
        case .systemImage(let name):
            Image(systemName: name)
                .font(.system(size: size * 0.5, weight: .medium))
                .foregroundStyle(foregroundColor)
                .frame(width: size, height: size)
                .background(Circle().fill(backgroundColor))
        case .image(let image):
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        }
    }
}

private extension String {
    /// Returns up to two uppercase initials from a name-style string.
    var avatarInitials: String {
        let parts = self
            .split(whereSeparator: { $0.isWhitespace })
            .compactMap { $0.first.map(String.init) }
        let first = parts.first ?? ""
        let last = parts.count > 1 ? (parts.last ?? "") : ""
        return (first + last).uppercased()
    }
}
