//
//  ShuRuKuangTFView.m
//  NaHu
//
//  Created by SADF on 16/10/31.
//  Copyright © 2016年 SADF. All rights reserved.
//

#import "ShuRuKuangTFView.h"

@interface ShuRuKuangTFView ()
{
    //商户
//    BOOL isShangHu;
}
@end

@implementation ShuRuKuangTFView

-(instancetype)initWithTitle:(NSString *)titleText placeholder:(NSString *)placeholderText image:(NSString *)image custom:(UIView *)custom {
    if (self == [super init]) {
        [self createToTitle:titleText placeholder:placeholderText image:image custom:custom];
    }
    return self;
}

-(void)createToTitle:(NSString *)titleText placeholder:(NSString *)placeholderText image:(NSString *)image custom:(UIView *)custom {
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = 1;
    self.backgroundColor = [UIColor whiteColor];
    
    kWEAKSELF(weakSelf);
    UIImageView * imageView = nil;
    if (image != nil) {
        imageView = [[UIImageView alloc] init];
        imageView.image = [UIImage imageNamed:image];
        [self addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(10);
            make.width.and.height.mas_equalTo(@15);
            make.centerY.mas_equalTo(weakSelf.mas_centerY);
        }];
    }
    
    MyLabel * title = [[MyLabel alloc] init];
    title.text = titleText;
    title.font = [CommonTools getPXFontSize:28];
    [self addSubview:title];
    self.titleLabel = title;
    CGSize size =[titleText sizeWithAttributes:@{NSFontAttributeName:title.font}];
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        if (image != nil) {
            make.left.equalTo(imageView.mas_right).with.offset(5);
        }else {
            make.left.offset(10);
        }
        make.centerY.equalTo(weakSelf);
        if (placeholderText != nil) {
            make.size.mas_equalTo(CGSizeMake(size.width+2, size.height));
        }else {
            make.size.mas_equalTo(CGSizeMake(size.width+1, size.height));
        }
    }];
    
    self.TextField = [[UITextField alloc] init];
    _TextField.placeholder = placeholderText;
    _TextField.font = [CommonTools getPXFontSize:28];
    [_TextField addTarget:self action:@selector(endTextField:) forControlEvents:(UIControlEventEditingDidEnd)];
    [_TextField addTarget:self action:@selector(returnKeyClick:) forControlEvents:(UIControlEventEditingDidEndOnExit)];
    _TextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [self addSubview:_TextField];
    
    if (custom != nil) {
        [self addSubview:custom];
        [custom mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.right.equalTo(weakSelf.mas_right).offset(-5);
            make.width.offset(70);
        }];
        
        [_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(title.mas_right).with.offset(5);
            make.right.equalTo(custom.mas_left).with.offset(1);
            make.height.mas_equalTo(AdaptiveHeight(40));
        }];
    }else {
        [_TextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakSelf);
            make.left.equalTo(title.mas_right).with.offset(5);
            make.right.equalTo(weakSelf.mas_right).with.offset(-1);
            make.height.mas_equalTo(AdaptiveHeight(40));
        }];
    }
    
    
    
//    [self insertSubview:_TextField aboveSubview:title];
}

-(void)endTextField:(UITextField *)textField {
    if (_TextField == textField) {
        if ([CommonTools kongGe:textField.text]) {
            if (self.hudText) {
                [MyMBProgressHUD hudForText:self.hudText call:^{
                    [textField resignFirstResponder];
                }];
            }
            
        }
    }
}

-(void)returnKeyClick:(UITextField *)tf {
    [tf becomeFirstResponder];
    if (_returnNext != nil) {
        [_returnNext becomeFirstResponder];
    }
    if (self.returnKeyClick) {
        self.returnKeyClick();
    }
}

-(void)setEnterNumber:(NSInteger)enterNumber {
    if (_enterNumber != enterNumber) {
        _enterNumber = enterNumber;
        if (_TextField) {
            [_TextField addTarget:self action:@selector(TextFieldChange:) forControlEvents:(UIControlEventAllEditingEvents)];
        }
    }
}

-(void)TextFieldChange:(UITextField *)textField {
    if (textField == _TextField) {
        NSString *aString = textField.text;
        UITextRange *selectedRange = [textField markedTextRange];
        // 獲取被選取的文字區域（在打注音時，還沒選字以前注音會被選起來）
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 沒有被選取的字才限制文字的輸入字數
        if (!position) {
            if (aString.length > _enterNumber) {
                textField.text = [aString substringToIndex:_enterNumber];
            }
        }
        if (self.textFieldChange) {
            self.textFieldChange(textField.text);
        }
//        if (textField.text.length >= _enterNumber) {
//            textField.text = [textField.text substringToIndex:_enterNumber];
//            return;
//        }
    }
}

#pragma -
-(instancetype)initWithSelect {
    if (self == [super init]) {
        kWEAKSELF(weakSelf);
        NSArray * title = @[@"个人帐户", @"商户帐户"];
        for (int i=0; i<2;i++) {
            UIButton * btn = [[UIButton alloc] init];
            btn.tag = i+10;
            [self addSubview:btn];
            
            btn.titleLabel.font = [CommonTools getPXFontSize:28];
            [btn setTitle:title[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:[CommonTools getColorWithHexString:@"333333"] forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"未选择"] forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"已选择"] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(selectClassClick:) forControlEvents:(UIControlEventTouchUpInside)];
            if (i == 0) {
                btn.selected = 1;
            }
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 15);
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(CGRectGetWidth(weakSelf.frame)/2));
                //.with.offset(CGRectGetWidth(weakSelf.frame)/2*i);
                if (i == 0) {
                    make.left.equalTo(weakSelf).with.offset(0);
                    make.right.equalTo(weakSelf.mas_centerX);
                }else {
                    make.left.equalTo(weakSelf.mas_centerX);
                    make.right.equalTo(@(CGRectGetWidth(weakSelf.frame)));
                }
                make.top.and.bottom.equalTo(weakSelf).with.offset(0);
            }];
        }
    }
    return self;
}

-(void)selectClassClick:(UIButton *)btn {
    btn.selected = YES;
    if (btn.tag == 10) {
        //个人
        UIButton * tempBtn = [self viewWithTag:11];
        tempBtn.selected = NO;
    }else {
        //商户
        UIButton * tempBtn = [self viewWithTag:10];
        tempBtn.selected = NO;
    }
}

-(instancetype)initWithSelect:(NSString *)titleText {
    if (self == [super init]) {
        kWEAKSELF(weakSelf);
        NSArray * titleArr = @[@"公用", @"私人"];
        
        MyLabel * title = [[MyLabel alloc] init];
        title.text = titleText;
        title.font = [CommonTools getPXFontSize:28];
        [self addSubview:title];
        self.titleLabel = title;
        CGSize size =[titleText sizeWithAttributes:@{NSFontAttributeName:title.font}];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
        }];
        
        UIView * view = [[UIView alloc] init];
        for (int i=0; i<2;i++) {
            UIButton * btn = [[UIButton alloc] init];
            btn.tag = i+10;
            [view addSubview:btn];
            
            btn.titleLabel.font = [CommonTools getPXFontSize:28];
            [btn setTitle:titleArr[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:[CommonTools getColorWithHexString:@"333333"] forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"未选择"] forState:(UIControlStateNormal)];
            [btn setImage:[UIImage imageNamed:@"已选择"] forState:(UIControlStateSelected)];
            [btn addTarget:self action:@selector(selectClassClick:) forControlEvents:(UIControlEventTouchUpInside)];
            if (i == 0) {
                btn.selected = 1;
            }
            btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@((weakSelf.frame.size.width)/2));
                //.with.offset(CGRectGetWidth(weakSelf.frame)/2*i);
                if (i == 0) {
                    make.left.offset(0);
                    make.right.equalTo(view.mas_centerX);
                }else {
                    make.left.equalTo(view.mas_centerX);
                    make.right.equalTo(@(CGRectGetWidth(view.frame)));
                }
                make.top.and.bottom.equalTo(view).with.offset(0);
            }];
        }
        [self addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(title.mas_right).with.offset(0);
            make.right.and.bottom.and.top.equalTo(weakSelf).with.offset(0);
        }];
    }
    return self;
}

-(instancetype)initWithSelectToPay:(NSString *)titleText {
    if (self == [super init]) {
        kWEAKSELF(weakSelf);
        
        MyLabel * title = [[MyLabel alloc] init];
        title.text = titleText;
        title.font = [CommonTools getPXFontSize:28];
        [self addSubview:title];
        self.titleLabel = title;
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(10);
            make.centerY.equalTo(weakSelf);
            make.size.mas_equalTo([CommonTools getSizeWiethForText:title.text font:title.font]);
        }];
        
        UIButton * tempBtn;
        NSArray * titles = @[@"50元", @"100元", @"200元"];
        for (int i=0; i<titles.count;i++) {
            UIButton * btn = [[UIButton alloc] init];
            btn.tag = i+15;
            [self addSubview:btn];
            
            btn.titleLabel.font = [CommonTools getPXFontSize:28];
            [btn setTitle:titles[i] forState:(UIControlStateNormal)];
            [btn setTitleColor:[CommonTools getColorWithHexString:@"333333"] forState:(UIControlStateNormal)];
            btn.layer.borderColor = [CommonTools getColorWithHexString:@"c9c9c9"].CGColor;
            btn.layer.borderWidth = 0.5;
            btn.layer.cornerRadius = 3;
            btn.layer.masksToBounds = 1;
            [btn addTarget:self action:@selector(selectPayClick:) forControlEvents:(UIControlEventTouchUpInside)];
            if (i == 0) {
                btn.selected = 1;
                [btn setBackgroundColor:[CommonTools getColorWithHexString:@"52b448"]];
            }
            CGFloat w = (kScreenW - 60 - [CommonTools getSizeWiethForText:title.text font:title.font].width)/3;
            switch (i) {
                case 0:
                    btn.sd_layout.leftSpaceToView(title, 10).centerYEqualToView(weakSelf).widthIs(w).heightIs(30);
                    break;
                case 1:
                    btn.sd_layout.leftSpaceToView(tempBtn, 10).centerYEqualToView(weakSelf).widthIs(w).heightIs(30);
                    break;
                case 2:
                    btn.sd_layout.leftSpaceToView(tempBtn, 10).centerYEqualToView(weakSelf).widthIs(w).heightIs(30);
                    break;
                    
                default:
                    break;
            }
            tempBtn = btn;
        }
    }
    return self;
}

-(void)selectPayClick:(UIButton *)btn {
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj setBackgroundColor:[UIColor whiteColor]];
            [obj setTitleColor:[CommonTools getColorWithHexString:@"333333"] forState:(UIControlStateNormal)];
        }
    }
    [btn setBackgroundColor:[CommonTools getColorWithHexString:@"52b448"]];
    [btn setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    self.isSelectBtn = btn.tag - 15;
    if (self.btnClickChange) {
        self.btnClickChange();
    }
}

-(void)setDeSelectBtn {
    for (id obj in self.subviews) {
        if ([obj isKindOfClass:[UIButton class]]) {
            [obj setBackgroundColor:[UIColor whiteColor]];
            [obj setTitleColor:[CommonTools getColorWithHexString:@"333333"] forState:(UIControlStateNormal)];
        }
    }
}

@end
