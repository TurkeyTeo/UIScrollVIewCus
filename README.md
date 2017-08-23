# UIScrollVIewCus
在日常开发当中几乎没有哪个项目没有用到UIScrollView，如此之高的使用频率如果仅仅只会调用API而不知道原理实现的话是远远不够的。



####1. bounds实现子视图一起移动

老生常谈的一个知识点：

- frame：该view在父view坐标系统中的位置和大小。（参照点是父坐标系统）

- bounds：该view在本坐标系的位置和大小。（参照点是本坐标系，以0,0点为起点）


如下代码：

```objective-c

    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(20, 20, 200, 200)];
//    [view1 setBounds:CGRectMake(-30, -30, 200, 200)];
    view1.backgroundColor = [UIColor redColor];
    [self.view addSubview:view1];//添加到self.view
    NSLog(@"view1 frame:%@========view1 bounds:%@",NSStringFromCGRect(view1.frame),NSStringFromCGRect(view1.bounds));
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view2.backgroundColor = [UIColor yellowColor];
    [view1 addSubview:view2];//添加到view1上,[此时view1坐标系左上角起点为(-30,-30)]
    NSLog(@"view2 frame:%@========view2 bounds:%@",NSStringFromCGRect(view2.frame),NSStringFromCGRect(view2.bounds));
```

但是如果将这句代码的注释打开：

```objective-c
[view1 setBounds:CGRectMake(-30, -30, 200, 200)];
```

同时，如果你如果不改动frame，但是修改了view1的bounds大小，view1也会做相应的放大缩小且坐标会变化，沿着四边溢出。

可见，bounds的有以下两个特点：

1. 它可以修改自己坐标系的原点位置，进而影响到“子view”的显示位置。这个作用更像是移动原点的意思。
2. bounds，它可以改变的frame。



> locationInView:获取到的是手指点击屏幕实时的坐标点；
>
> translationInView：获取到的是手指移动后，相对于手势第一次作用在view上的点的偏移量。



这也是UIScrollView的核心原理所在。在UIScrollView的frame和其subViews的frame未变化的情况下，修改bounds原点就相当于在平面上移动这个可视区域！

<br>

#### 2. panGestureRecognize实现滑动

实际上UIScrollView是继承自UIView，是不可能自己滑动的，添加了一个panGestureRecognize滑动手势来实现滑动的。

<br>

以下为自己实现简单ScrollView的大致代码：

```objective-c
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    UIPanGestureRecognizer *panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panG];
    self.layer.masksToBounds = YES;
    return self;
}

- (void)panGesture:(UIPanGestureRecognizer *)pan{
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.startPoint = self.bounds.origin;
    }
    else if (pan.state == UIGestureRecognizerStateChanged){
        CGPoint point = [pan translationInView:self];
        CGFloat newStartX = self.startPoint.x - point.x;
        CGFloat newStartY = self.startPoint.y - point.y;
        
        CGRect bounds = self.bounds;
        bounds.origin = CGPointMake(newStartX, newStartY);
        
        if (bounds.origin.x + bounds.size.width > _contentSize.width) {
            bounds.origin.x = _contentSize.width - bounds.size.width;
        }
        if (bounds.origin.y + bounds.size.height > _contentSize.height) {
            bounds.origin.y = _contentSize.height - bounds.size.height;
        }
        if (bounds.origin.x < 0) {
            bounds.origin.x = 0;
        }
        if (bounds.origin.y < 0) {
            bounds.origin.y = 0;
        }
        self.bounds = bounds;
    }
}

- (void)setContentSize:(CGSize)contentSize{
    _contentSize = contentSize;
    CGRect bounds = self.bounds;
    bounds.origin = _contentOffset;
}
```





#### 3. touch事件处理：

#####3.1 当手指触摸后，UIScrollView会暂时拦截触摸事件,使用一个计时器，假如在计时器到点后，没有发生手指移动事件，那么UIScrollView会发送tracking events到被点击的subview。假如在计时器到点前，发生了移动事件，那么UIScrollView取消tracking自己发生滚动。

为了检测touch是处理还是传递，UIScrollView当touch发生时会生成一个timer。

1. 如果150ms内touch未产生移动，它就把这个事件传递给内部view；
2. 如果150ms内touch产生移动，开始scrolling，不会传递给内部的view。（如当你touch一个table时候，直接scrolling，你touch的那行永远不会highlight。）
3. 如果150ms内touch未产生移动并且UIScrollView开始传递内部的view事件，但是移动足够远的话，且canCancelContentTouches = YES，UIScrollView会调用touchesCancelled方法，cancel掉内部view的事件响应,并开始scrolling。（如当你touch一个table， 停止了一会，然后开始scrolling，那一行就首先被highlight，但是随后就不在高亮了）

#####3.2 子类可以重载touchesShouldBegin:withEvent:inContentView: 决定自己是否接收touch事件。pagingEnabled当值是YES，会自动滚动到subview的边界，默认是NO。touchesShouldCancelInContentView: 开始发送tracking messages消息给subview的时候会调用这个方法，决定是否发送tracking messages消息到subview，假如返回NO会发送；YES则不发送。假如 canCancelContentTouches属性是NO,则不调用这个方法来影响如何处理滚动手势



