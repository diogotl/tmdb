//
//  SkeletonCell.swift
//  tmdb
//
//  Created by Diogo on 19/10/2025.
//

import UIKit

class SkeletonCell: UITableViewCell {

    static let reuseIdentifier = "SkeletonCell"

    private let skeletonImageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 6
        return view
    }()

    private let skeletonTitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray5
        view.layer.cornerRadius = 4
        return view
    }()

    private let skeletonSubtitleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 4
        return view
    }()

    private lazy var textStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [skeletonTitleView, skeletonSubtitleView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()

    private lazy var mainStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [skeletonImageView, textStackView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 16.0
        stack.alignment = .top
        stack.distribution = .fill
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupConstraints()
        startShimmering()
        selectionStyle = .none
        backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setupConstraints()
        startShimmering()
        selectionStyle = .none
        backgroundColor = .systemBackground
    }

    private func setupViews() {
        contentView.addSubview(mainStackView)
    }

    private func setupConstraints() {
        let spacing: CGFloat = 12

        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: spacing),
            mainStackView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -spacing),

            skeletonImageView.widthAnchor.constraint(equalToConstant: 80),
            skeletonImageView.heightAnchor.constraint(equalToConstant: 120),

            skeletonTitleView.heightAnchor.constraint(equalToConstant: 20),
            skeletonSubtitleView.heightAnchor.constraint(equalToConstant: 16),
        ])

        skeletonImageView.setContentHuggingPriority(.required, for: .horizontal)
        textStackView.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }

    private func startShimmering() {
        let views = [skeletonImageView, skeletonTitleView, skeletonSubtitleView]

        views.forEach { view in
            let shimmerLayer = CAGradientLayer()
            shimmerLayer.colors = [
                UIColor.systemGray5.cgColor,
                UIColor.systemGray4.cgColor,
                UIColor.systemGray5.cgColor,
            ]
            shimmerLayer.startPoint = CGPoint(x: 0, y: 0.5)
            shimmerLayer.endPoint = CGPoint(x: 1, y: 0.5)
            shimmerLayer.locations = [0, 0.5, 1]

            view.layer.addSublayer(shimmerLayer)

            DispatchQueue.main.async {
                shimmerLayer.frame = view.bounds

                let animation = CABasicAnimation(keyPath: "locations")
                animation.fromValue = [-1.0, -0.5, 0.0]
                animation.toValue = [1.0, 1.5, 2.0]
                animation.duration = 1.5
                animation.repeatCount = .infinity

                shimmerLayer.add(animation, forKey: "shimmer")
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        // Update shimmer layer frames
        for subview in [skeletonImageView, skeletonTitleView, skeletonSubtitleView] {
            if let shimmerLayer = subview.layer.sublayers?.first as? CAGradientLayer {
                shimmerLayer.frame = subview.bounds
            }
        }
    }
}
