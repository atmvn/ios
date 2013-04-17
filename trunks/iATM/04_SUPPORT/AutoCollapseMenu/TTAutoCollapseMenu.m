//
//  TTAutoCollapseMenu.m
//  AutoCollapseMenu
//
//  Created by Tai Truong on 4/17/13.
//  Copyright (c) 2013 Tai Truong. All rights reserved.
//

#import "TTAutoCollapseMenu.h"


@implementation TTAutoCollapseMenu
{
    UIView *_firstItem;
    UIView *_selectedItem;
    BOOL _isExpanded;
    NSMutableDictionary *_item2Index;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, AUTOEXPANDMENU_MENU_HEIGHT + 6.0f)]))
    {
        _isExpanded = NO;
		[self setup];
	}
	return self;
}

-(id)initWithFrame:(CGRect)frame atPosition:(enumTTAutoCollapseMenuPosition)position
{
    CGFloat posY = position == enumTTAutoCollapseMenuPosition_Top ? 0 : (frame.size.height - AUTOEXPANDMENU_MENU_HEIGHT);
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, posY, frame.size.width, AUTOEXPANDMENU_MENU_HEIGHT + 6.0f)]))
    {
        _isExpanded = NO;
		[self setup];
	}
	return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setup {
	self.opaque = NO;
	self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	
	_titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	_titleLabel.font = [UIFont boldSystemFontOfSize:17.5f];
	_titleLabel.numberOfLines = 0;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.textColor = [UIColor blackColor];
	_titleLabel.shadowColor = [UIColor whiteColor];
	_titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
	_titleLabel.hidden = NO;
	_titleLabel.opaque = NO;
	[self addSubview:_titleLabel];
	
	_actionPickerView = [[UIView alloc] initWithFrame:CGRectZero];
	_actionPickerView.layer.cornerRadius = AUTOEXPANDMENU_ITEM_RADIUS;
	_actionPickerView.layer.borderWidth = 1.0f;
	_actionPickerView.layer.borderColor = [UIColor darkGrayColor].CGColor;
	_actionPickerView.clipsToBounds = YES;
	
	_actionPickerGradientLayer = [CAGradientLayer layer];
	_actionPickerGradientLayer.anchorPoint = CGPointMake(0.0f, 0.0f);
	_actionPickerGradientLayer.position = CGPointMake(0.0f, 0.0f);
	_actionPickerGradientLayer.startPoint = CGPointZero;
	_actionPickerGradientLayer.endPoint = CGPointMake(0.0f, 1.0f);
	_actionPickerGradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor grayColor].CGColor, (id)[UIColor darkGrayColor].CGColor, nil];
	[_actionPickerView.layer addSublayer:_actionPickerGradientLayer];
	
	[self addSubview:_actionPickerView];
	
	UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionPickerViewTap:)];
	[_actionPickerView addGestureRecognizer:tapGesture];
    _actionPickerView.backgroundColor = [UIColor greenColor];
    
	_borderGradientHidden = NO;
    
    [self loadItems];
}

-(void)loadItems
{
    NSInteger numItems = [self.delegate numberOfItemInAutoCollapseMenu];
    
    for (UIView *subview in _actionPickerView.subviews) {
        [subview removeFromSuperview];
    }
    
    if (_items) {
        [_items removeAllObjects];
    }
    else {
        _items = [[NSMutableArray alloc] init];
    }
    _item2Index = [[NSMutableDictionary alloc] initWithCapacity:numItems];
    
    for (NSInteger i = 0; i < numItems; i++) {
        // get item view at index i
        UIView *itemView = [self.delegate autoCollapseMenu:self viewForItemAtIndex:i];
        
        // init frame
        itemView.frame = CGRectMake(0.0f, 0.0f, AUTOEXPANDMENU_ITEM_WIDTH, AUTOEXPANDMENU_ITEM_HEIGHT);
        itemView.center = CGPointMake((AUTOEXPANDMENU_ITEM_WIDTH / 2 + i * AUTOEXPANDMENU_ITEM_WIDTH), AUTOEXPANDMENU_ITEM_RADIUS);
        
        // add to menu view
        [_actionPickerView addSubview:itemView];
        // add gesture to menu item
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionPickerViewTap:)];
        [itemView addGestureRecognizer:tapGesture];
        
        // add to item view array
        [_items addObject:itemView];
        // add item, index to hash table
        [_item2Index setValue:@(i) forKey:[self getObjectString:itemView]];
        
        // show first item
        if (i == 0) {
            _firstItem = _selectedItem = itemView;
        }
    }
    
}

-(void)addSubview:(UIView *)view
{
    [super addSubview:view];
    [self bringSubviewToFront:_actionPickerView];
}

#pragma mark - Utilities
-(void)shrinkActionPicker
{
    
}

-(void)reloadData
{
    [self loadItems];
}

-(NSString*)getObjectString:(id)object
{
    return [NSString stringWithFormat: @"%p", object];
}

#pragma mark Layout & Redraw

- (void)layoutSubviews {
    self.titleLabel.frame = CGRectMake(12.0f, (AUTOEXPANDMENU_MENU_HEIGHT - 45.0f )/2, self.frame.size.width - AUTOEXPANDMENU_MENU_HEIGHT, 45.0f);
    _actionPickerGradientLayer.bounds = CGRectMake(0.0f, 0.0f, self.frame.size.width - 2*MENU_PADDING, AUTOEXPANDMENU_ITEM_HEIGHT);
    
    NSLog(@"AUTOEXPANDMENU_MENU_HEIGHT = %f", AUTOEXPANDMENU_MENU_HEIGHT);
    NSLog(@"MENU_PADDING = %f", MENU_PADDING);
    NSLog(@"AUTOEXPANDMENU_ITEM_WIDTH = %f", AUTOEXPANDMENU_ITEM_WIDTH);
    NSLog(@"AUTOEXPANDMENU_ITEM_HEIGHT = %f", AUTOEXPANDMENU_ITEM_HEIGHT);
    NSLog(@"AUTOEXPANDMENU_ITEM_RADIUS = %f", AUTOEXPANDMENU_ITEM_RADIUS);
    
    NSLog(@"self = %@", self);
	if (CGRectIsEmpty(_actionPickerView.frame)) {
        _isExpanded = NO;
		_actionPickerView.frame = CGRectMake(self.frame.size.width - (AUTOEXPANDMENU_ITEM_WIDTH + MENU_PADDING), (AUTOEXPANDMENU_MENU_HEIGHT - AUTOEXPANDMENU_ITEM_HEIGHT) / 2, AUTOEXPANDMENU_ITEM_WIDTH, AUTOEXPANDMENU_ITEM_HEIGHT);
        NSLog(@"menu = %@", _actionPickerView);
	} else {
        __block __typeof__(self) blockSelf = self;
        CGRect selectedItemRect = _firstItem.frame;
		[UIView animateWithDuration:0.6
						 animations:^{
							 if (blockSelf.titleLabel.isHidden) {
								 _actionPickerView.frame = CGRectMake(MENU_PADDING, (AUTOEXPANDMENU_MENU_HEIGHT - AUTOEXPANDMENU_ITEM_HEIGHT) / 2 , blockSelf.frame.size.width - 2*MENU_PADDING, AUTOEXPANDMENU_ITEM_WIDTH);
                                 
							 } else {
                                 if(_firstItem != _selectedItem)
                                 {
                                     _firstItem.frame = _selectedItem.frame;
                                     _selectedItem.frame = selectedItemRect;
                                 }
								 _actionPickerView.frame = CGRectMake(blockSelf.frame.size.width - (AUTOEXPANDMENU_ITEM_WIDTH + MENU_PADDING), (AUTOEXPANDMENU_MENU_HEIGHT - AUTOEXPANDMENU_ITEM_HEIGHT) / 2 , AUTOEXPANDMENU_ITEM_WIDTH, AUTOEXPANDMENU_ITEM_WIDTH);
							 }
						 } completion:^(BOOL finished) {
                             if (blockSelf.titleLabel.isHidden) {
                                 _isExpanded = YES;
                                 
							 } else {
                                 _isExpanded = NO;
                                 _firstItem = _selectedItem;
							 }
                         }];
	}
}

- (void)drawRect:(CGRect)rect {
    
	CGFloat colors[] = {
		200.0f / 255.0f, 207.0f / 255.0f, 212.0f / 255.0f, 1.0f,
        169.0f / 255.0f, 178.0f / 255.0f, 185.0f / 255.0f, 1.0f
	};
	[self drawLinearGradientInRect:CGRectMake(0.0f, 0.0f, rect.size.width, AUTOEXPANDMENU_MENU_HEIGHT) colors:colors];
    
    if (!self.borderGradientHidden) {
        CGFloat colors2[] = {
            152.0f / 255.0f, 156.0f / 255.0f, 161.0f / 255.0f, 0.5f,
            152.0f / 255.0f, 156.0f / 255.0f, 161.0f / 255.0f, 0.1f
        };
        [self drawLinearGradientInRect:CGRectMake(0.0f, AUTOEXPANDMENU_MENU_HEIGHT + 1.0f, rect.size.width, 5.0f) colors:colors2];
    }
    
    CGFloat line1[]={240.0f / 255.0f, 230.0f / 255.0f, 230.0f / 255.0f, 1.0f};
    [self drawLineInRect:CGRectMake(0.0f, 0.0f, rect.size.width, 0.0f) colors:line1];
    
    CGFloat line2[]={94.0f / 255.0f,  103.0f / 255.0f, 109.0f / 255.0f, 1.0f};
    [self drawLineInRect:CGRectMake(0.0f, AUTOEXPANDMENU_MENU_HEIGHT + 0.5f, rect.size.width, 0.0f) colors:line2];
}

#pragma mark Drawing private methods

- (void)drawLinearGradientInRect:(CGRect)rect colors:(CGFloat[])colours {
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSaveGState(context);
	
	CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
	CGGradientRef gradient = CGGradientCreateWithColorComponents(rgb, colours, NULL, 2);
	CGColorSpaceRelease(rgb);
	CGPoint start, end;
	
	start = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.25);
	end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height * 0.75);;
	
	CGContextClipToRect(context, rect);
	CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
	
	CGGradientRelease(gradient);
	
	CGContextRestoreGState(context);
}

- (void)drawLineInRect:(CGRect)rect colors:(CGFloat[])colors {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSaveGState(context);
	
	CGContextSetRGBStrokeColor(context, colors[0], colors[1], colors[2], colors[3]);
	CGContextSetLineCap(context, kCGLineCapButt);
	CGContextSetLineWidth(context, 1.0f);
	
	CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
	CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
	CGContextStrokePath(context);
	
	CGContextRestoreGState(context);
}

#pragma mark Accessors

- (void)setBorderGradientHidden:(BOOL)newBorderGradientHidden {
    _borderGradientHidden = newBorderGradientHidden;
    [self setNeedsDisplay];
}

- (BOOL)isActionPickerExpanded {
	return (self.titleLabel.isHidden && _actionPickerView.bounds.size.width != AUTOEXPANDMENU_ITEM_WIDTH);
}

//- (void)setItems:(NSArray *)newItems {
//    if (newItems.count > 0 && _items != newItems) {
//        for (UIView *subview in _actionPickerView.subviews) {
//            [subview removeFromSuperview];
//        }
//        
//        _items = [NSMutableArray arrayWithArray:newItems];
//        _firstItem = _selectedItem = [_items objectAtIndex:0];
//        for (UIView *item in _items) {
//			if ([item isKindOfClass:[UIView class]]) {
//				[_actionPickerView addSubview:item];
//                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleActionPickerViewTap:)];
//                [item addGestureRecognizer:tapGesture];
//			}
//        }
//    }
//}

#pragma mark -
#pragma mark UITapGestureRecognizer & UIGestureRecognizerDelegate

- (void)handleActionPickerViewTap:(UIGestureRecognizer *)gestureRecognizer {
//    NSLog(@"handleActionPickerViewTap-0 item tag = %d", gestureRecognizer.view.tag);
    self.titleLabel.hidden = !self.titleLabel.isHidden;
    if(_isExpanded && [_items containsObject:gestureRecognizer.view])
    {
        _selectedItem = gestureRecognizer.view;
        [_actionPickerView bringSubviewToFront:_selectedItem];
        
        // did select menu item
        if ([self.delegate respondsToSelector:@selector(autoCollapseMenu:didSelectItemAtIndex:)]) {
            [self.delegate autoCollapseMenu:self didSelectItemAtIndex:[[_item2Index valueForKey:[self getObjectString:_selectedItem]] integerValue]];
        }
    }
    
    [self setNeedsLayout];
}

@end
