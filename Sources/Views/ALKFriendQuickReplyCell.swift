//
//  ALKFriendQuickReplyCell.swift
//  ApplozicSwift
//
//  Created by Shivam Pokhriyal on 07/01/19.
//

class ALKFriendQuickReplyCell: ALKChatBaseCell<ALKMessageViewModel> {

    static let quickReplyViewWidth = UIScreen.main.bounds.width -
        (QuickReplyConfig.ReceivedMessage.QuickReplyPadding.left + QuickReplyConfig.ReceivedMessage.QuickReplyPadding.right)

    var messageView = ALKFriendMessageView()
    var quickReplyView = ALKQuickReplyView(frame: .zero, maxWidth: ALKFriendQuickReplyCell.quickReplyViewWidth)
    lazy var messageViewHeight = self.messageView.heightAnchor.constraint(equalToConstant: 0)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func update(viewModel: ALKMessageViewModel) {
        let messageWidth = UIScreen.main.bounds.width -
            (QuickReplyConfig.ReceivedMessage.MessagePadding.left + QuickReplyConfig.ReceivedMessage.MessagePadding.right)
        let height = ALKFriendMessageView.rowHeight(viewModel: viewModel, width: messageWidth)
        messageViewHeight.constant = height
        messageView.update(viewModel: viewModel)
        guard let quickReplyArray = viewModel.quickReplyDictionary() else {
            self.layoutIfNeeded()
            return
        }
        updateQuickReplyView(quickReplyArray: quickReplyArray, height: height)
        self.layoutIfNeeded()
    }

    class func rowHeight(viewModel: ALKMessageViewModel) -> CGFloat {
        let messageWidth = UIScreen.main.bounds.width -
            (QuickReplyConfig.ReceivedMessage.MessagePadding.left + QuickReplyConfig.ReceivedMessage.MessagePadding.right)
        let height = ALKFriendMessageView.rowHeight(viewModel: viewModel, width: messageWidth)
        guard let quickReplyDict = viewModel.quickReplyDictionary() else {
            return height
        }
        return height + ALKQuickReplyView.rowHeight(quickReplyArray: quickReplyDict, maxWidth: quickReplyViewWidth) + 20 // Padding between messages
    }

    private func setupConstraints() {
        self.contentView.addSubview(messageView)
        messageView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(quickReplyView)
        messageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: QuickReplyConfig.ReceivedMessage.MessagePadding.top).isActive = true
        messageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: QuickReplyConfig.ReceivedMessage.MessagePadding.left).isActive = true
        messageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -1 * QuickReplyConfig.ReceivedMessage.MessagePadding.right).isActive = true
        messageViewHeight.isActive = true
    }

    private func updateQuickReplyView(quickReplyArray: [Dictionary<String, Any>], height: CGFloat) {
        quickReplyView.update(quickReplyArray: quickReplyArray)
        let quickReplyViewWidth = ALKFriendQuickReplyCell.quickReplyViewWidth
        let quickReplyViewHeight = ALKQuickReplyView.rowHeight(quickReplyArray: quickReplyArray, maxWidth: quickReplyViewWidth)

        quickReplyView.frame = CGRect(x: QuickReplyConfig.ReceivedMessage.QuickReplyPadding.left,
                                      y: height + QuickReplyConfig.ReceivedMessage.QuickReplyPadding.top,
                                      width: quickReplyViewWidth,
                                      height: quickReplyViewHeight)
    }
}
