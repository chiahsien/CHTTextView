//
//  CHTTextView.m
//
//  Created by Nelson Tai on 2013/11/23.
//  Copyright (c) 2013年 Nelson Tai. All rights reserved.
//

#import "CHTTextView.h"

@implementation CHTTextView

#pragma mark - Accessors

- (void)setPlaceholder:(NSString *)placeholder {
  if ([_placeholder isEqualToString:placeholder]) {
    return;
  }
  _placeholder = [placeholder copy];
  [self setNeedsDisplay];
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor {
  _placeholderTextColor = placeholderTextColor;
  [self setNeedsDisplay];
}

- (void)setText:(NSString *)string {
  [super setText:string];
  [self setNeedsDisplay];
}

- (void)insertText:(NSString *)string {
  [super insertText:string];
  [self setNeedsDisplay];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
  [super setAttributedText:attributedText];
  [self setNeedsDisplay];
}

- (void)setContentInset:(UIEdgeInsets)contentInset {
  [super setContentInset:contentInset];
  [self setNeedsDisplay];
}

- (void)setFont:(UIFont *)font {
  [super setFont:font];
  [self setNeedsDisplay];
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
  [super setTextAlignment:textAlignment];
  [self setNeedsDisplay];
}

#pragma mark - NSObject

- (void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self
                                                  name:UITextViewTextDidChangeNotification
                                                object:self];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  if (self = [super initWithCoder:aDecoder]) {
    [self commonInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame {
  if (self = [super initWithFrame:frame]) {
    [self commonInit];
  }
  return self;
}

- (id)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
  if (self = [super initWithFrame:frame textContainer:textContainer]) {
    [self commonInit];
  }
  return self;
}

- (void)drawRect:(CGRect)rect {
  [super drawRect:rect];

  if (!(self.text.length == 0 && self.placeholder.length > 0)) {
    return;
  }

  // Draw the text
  rect = [self placeholderRectForBounds:self.bounds];

  if ([self.placeholder respondsToSelector:@selector(drawInRect:withAttributes:)]) {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:self.typingAttributes];
    attributes[NSForegroundColorAttributeName] = self.placeholderTextColor;
    [self.placeholder drawInRect:rect withAttributes:attributes];
  } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.placeholderTextColor set];
    [self.placeholder drawInRect:rect
                        withFont:self.font
                   lineBreakMode:NSLineBreakByWordWrapping
                       alignment:self.textAlignment];
#pragma clang diagnostic pop
  }
}

#pragma mark - Private Methods

- (void)commonInit {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(textChanged:)
                                               name:UITextViewTextDidChangeNotification
                                             object:self];

  self.placeholderTextColor = [UIColor colorWithWhite:0.700 alpha:1.000];
}

- (void)textChanged:(NSNotification *)notification {
  [self setNeedsDisplay];
}

- (CGRect)placeholderRectForBounds:(CGRect)bounds {
  // Inset the rect
  CGRect rect = UIEdgeInsetsInsetRect(bounds, self.contentInset);
  rect = CGRectInset(rect, 5, 8); // Take cursor position into consideration

  return rect;
}

@end
