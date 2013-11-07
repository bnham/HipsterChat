//
//  ChatViewController.m
//  HipsterChat
//
//  Created by Ben Nham on 11/5/13.
//  Copyright (c) 2013 Thomas Bouldin. All rights reserved.
//

#import "ChatViewController.h"
#import "Chat.h"

static CGFloat kVerticalPadding = 4;
static CGFloat kHorizontalPadding = 5;

static CGFloat kTitleHeight = 15;
static CGFloat kTitleSpacing = 2;
static CGFloat kDateHeight = 15;
static CGFloat kDateSpacing = 2;

static CGFloat kTextFieldHeight = 25;

#pragma mark - ChatViewTableCell

@interface ChatTableViewCell : UITableViewCell {
    UILabel *_titleLabel;
    UILabel *_textLabel;
    UILabel *_dateLabel;
}
@end

@implementation ChatTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
        UIView *contentView = [self contentView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRed:87.0/255 green:107.0/255 blue:149.0/255 alpha:1.0];
        [contentView addSubview:_titleLabel];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont systemFontOfSize:14];
        _textLabel.numberOfLines = 0;
        [contentView addSubview:_textLabel];
        
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = [UIFont systemFontOfSize:12];
        _dateLabel.textColor = [UIColor grayColor];
        [contentView addSubview:_dateLabel];
        
        [contentView addSubview:_textLabel];
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = CGRectInset(self.bounds, kHorizontalPadding, kVerticalPadding);
    
    CGRect titleFrame = bounds;
    titleFrame.size.height = kTitleHeight;
    _titleLabel.frame = titleFrame;
    
    CGRect textLabelFrame = bounds;
    textLabelFrame.origin.y = CGRectGetMaxY(titleFrame) + kTitleSpacing;
    textLabelFrame.size.height = bounds.size.height - kTitleHeight - kTitleSpacing - kDateHeight - kDateSpacing;
    _textLabel.frame = textLabelFrame;
    
    CGRect dateFrame = bounds;
    dateFrame.origin.y = CGRectGetMaxY(bounds) - kDateHeight;
    dateFrame.size.height = kDateHeight;
    _dateLabel.frame = dateFrame;
}

- (void)setTitle:(NSString *)title text:(NSString *)text date:(NSDate *)date {
    static NSDateFormatter *__formatter = nil;
    if (__formatter == nil) {
        __formatter = [[NSDateFormatter alloc] init];
        [__formatter setDateStyle:NSDateFormatterShortStyle];
        [__formatter setTimeStyle:NSDateFormatterShortStyle];
        [__formatter setDoesRelativeDateFormatting:YES];
    }
    
    _titleLabel.text = title;
    _textLabel.text = text;
    _dateLabel.text = [__formatter stringFromDate:date];
}

+ (CGFloat)heightForText:(NSString *)text {
    UILabel *__sizingLabel;
    if (__sizingLabel == nil) {
        __sizingLabel = [[UILabel alloc] init];
        __sizingLabel.font = [UIFont systemFontOfSize:14];
        __sizingLabel.numberOfLines = 0;
    }
    
    CGRect rect = CGRectInset([UIScreen mainScreen].bounds, kHorizontalPadding, 0);
    __sizingLabel.text = text;
    
    return [__sizingLabel sizeThatFits:rect.size].height + kTitleHeight + kTitleSpacing + kDateHeight + kDateSpacing + 2 * kVerticalPadding;
}

@end

#pragma mark - ChatEntryView

@protocol ChatEntryViewDelegate
- (void)didEnterTitle:(NSString *)title message:(NSString *)message;
@end

@interface ChatEntryView : UIView<UITextFieldDelegate> {
    UIView *_topSeparatorView;
    UITextField *_titleField;
    UIView *_middleSeparatorView;
    UITextField *_messageField;
}

@property (nonatomic, strong) UITextField *titleField;
@property (nonatomic, strong) UITextField *messageField;
@property (nonatomic, weak) id<ChatEntryViewDelegate> delegate;

@end

@implementation ChatEntryView

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        UIColor *separatorColor = [UIColor colorWithRed:178.0/255 green:178.0/255 blue:178.0/255 alpha:1.0];
        self.backgroundColor = [UIColor colorWithRed:248.0/255 green:248.0/255 blue:248.0/255 alpha:1.0];
        
        _topSeparatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _topSeparatorView.backgroundColor = separatorColor;
        [self addSubview:_topSeparatorView];
        
        _titleField = [[UITextField alloc] initWithFrame:CGRectZero];
        _titleField.font = [UIFont systemFontOfSize:14];
        _titleField.placeholder = @"Title";
        _titleField.returnKeyType = UIReturnKeySend;
        _titleField.delegate = self;
        [self addSubview:_titleField];
        
        _middleSeparatorView = [[UIView alloc] initWithFrame:CGRectZero];
        _middleSeparatorView.backgroundColor = separatorColor;
        [self addSubview:_middleSeparatorView];
        
        _messageField = [[UITextField alloc] initWithFrame:CGRectZero];
        _messageField.font = [UIFont systemFontOfSize:14];
        _messageField.placeholder = @"Message";
        _messageField.returnKeyType = UIReturnKeySend;
        _messageField.delegate = self;
        
        [self addSubview:_messageField];
    }
    
    return self;
}

- (void)dealloc {
    _titleField.delegate = nil;
    _messageField.delegate = nil;
}

- (void)layoutSubviews {
    CGRect bounds = self.bounds;
    
    CGRect topSeparatorFrame = CGRectMake(0, 0, bounds.size.width, 0.5);
    _topSeparatorView.frame = topSeparatorFrame;
    
    CGRect insetBounds = CGRectInset(bounds, kHorizontalPadding, 0);
    CGRect titleFieldFrame = CGRectMake(insetBounds.origin.x, kVerticalPadding, insetBounds.size.width, kTextFieldHeight);
    _titleField.frame = titleFieldFrame;
    
    CGRect middleSeparatorFrame = CGRectMake(insetBounds.origin.x, CGRectGetMaxY(titleFieldFrame) + kVerticalPadding / 2, insetBounds.size.width, 0.5);
    _middleSeparatorView.frame = middleSeparatorFrame;
    
    CGRect messageFieldFrame = CGRectMake(insetBounds.origin.x, CGRectGetMaxY(titleFieldFrame) + kVerticalPadding, insetBounds.size.width, kTextFieldHeight);
    _messageField.frame = messageFieldFrame;
}

- (CGSize)sizeThatFits:(CGSize)boundingSize {
    CGFloat width = boundingSize.width;
    CGFloat height = kVerticalPadding + kTextFieldHeight + kVerticalPadding + kTextFieldHeight + kVerticalPadding;
    
    return CGSizeMake(width, height);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_delegate didEnterTitle:_titleField.text message:_messageField.text];
    _titleField.text = nil;
    _messageField.text = nil;
    [textField resignFirstResponder];
    
    return NO;
}

@end

#pragma mark - ChatViewController

@interface ChatViewController()<UITableViewDataSource, UITableViewDelegate, ChatEntryViewDelegate> {
    NSArray *_messages;
    UITableView *_tableView;
    ChatEntryView *_entryView;
    CGRect _keyboardFrame;
}
@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.title = @"HipsterChat";
        
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        [nc addObserver:self
               selector:@selector(keyboardWillShow:)
                   name:UIKeyboardWillShowNotification object:nil];
        
        [nc addObserver:self
               selector:@selector(keyboardWillHide:)
                   name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)dealloc {
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
    _entryView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsSelection = NO;
    
    if ([_tableView respondsToSelector:@selector(setKeyboardDismissMode:)]) {
        [_tableView setKeyboardDismissMode:UIScrollViewKeyboardDismissModeOnDrag];
    }
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, kHorizontalPadding, 0, kHorizontalPadding)];
    }
    
    _entryView = [[ChatEntryView alloc] initWithFrame:CGRectZero];
    _entryView.delegate = self;
    
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
    containerView.backgroundColor = [UIColor whiteColor];
    [containerView addSubview:_tableView];
    [containerView addSubview:_entryView];
    
    self.view = containerView;
}

- (void)viewDidLayoutSubviews {
    CGRect bounds = self.view.bounds;
    CGFloat entryViewHeight = [_entryView sizeThatFits:bounds.size].height;
    
    CGRect tableViewFrame = bounds;
    tableViewFrame.size.height -= entryViewHeight;
    _tableView.frame = tableViewFrame;
    
    CGRect entryViewFrame = bounds;
    entryViewFrame.origin.y = bounds.size.height - _keyboardFrame.size.height - entryViewHeight;
    entryViewFrame.size.height = entryViewHeight;
    _entryView.frame = entryViewFrame;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshWithBlock:NULL];
}

- (void)refreshWithBlock:(PFBooleanResultBlock)block {
    PFQuery *query = [PFQuery queryWithClassName:@"Chat"];
    [query orderByDescending:@"createdAt"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error querying objects: %@", error);
        } else {
            _messages = [objects copy];
            [_tableView reloadData];
        }
        
        if (block != NULL) {
            block(error != nil, error);
        }
    }];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ReuseIdentifier = @"ChatTableViewCell";
    ChatTableViewCell *cell = (ChatTableViewCell *)[tableView dequeueReusableCellWithIdentifier:ReuseIdentifier];
    
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ReuseIdentifier];
    }
    
    Chat *chat = _messages[indexPath.row];
    NSString *title = chat.title ?: @"Untitled Masterwork";
    NSString *text = chat.text ?: @"No text";
    [cell setTitle:title text:text date:chat.updatedAt];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Chat *chat = _messages[indexPath.row];
    return [ChatTableViewCell heightForText:chat.text];
}

#pragma mark -
#pragma mark ChatEntryViewDelegate

- (void)didEnterTitle:(NSString *)title message:(NSString *)message {
    Chat *chat = [[Chat alloc] init];
    chat.title = title;
    chat.text = message;
    
    [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            [self refreshWithBlock:NULL];
        } else {
            NSLog(@"Failed to save object: %@", error);
        }
    }];
}

#pragma mark -
#pragma mark Keyboard

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    _keyboardFrame = [info[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    [self.view setNeedsLayout];
    
    [UIView beginAnimations:@"keyboard-show" context:NULL];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    UIEdgeInsets inset = UIEdgeInsetsMake(0, 0, _keyboardFrame.size.height, 0);
    _tableView.contentInset = inset;
    _tableView.scrollIndicatorInsets = inset;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [info[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    NSUInteger curve = [info[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue];
    
    _keyboardFrame = CGRectZero;
    
    [self.view setNeedsLayout];
    
    [UIView beginAnimations:@"keyboard-hide" context:NULL];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationDuration:duration];
    
    _tableView.contentInset = UIEdgeInsetsZero;
    _tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
}

@end
