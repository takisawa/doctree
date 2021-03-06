###nonref

= 2. 変数、定数、引数

* ((<FAQ::変数、定数、引数/2.1 変数や定数への代入によりオブジェクトはコピーされますか>))
* ((<FAQ::変数、定数、引数/2.2 ローカル変数のスコープはどのように決められていますか>))
* ((<FAQ::変数、定数、引数/2.3 ローカル変数はいつ参照可能になるのでしょうか>))
* ((<FAQ::変数、定数、引数/2.4 定数のスコープはどのように決められていますか>))
* ((<FAQ::変数、定数、引数/2.5 実引数は仮引数にどのように渡されますか>))
* ((<FAQ::変数、定数、引数/2.6 仮引数に代入すると実引数に影響を及ぼしますか>))
* ((<FAQ::変数、定数、引数/2.7 仮引数の指すオブジェクトにメッセージを送るとどうなりますか>))
* ((<FAQ::変数、定数、引数/2.8 (({*}))がついた引数は何ですか>))
* ((<FAQ::変数、定数、引数/2.9 (({&}))がついた引数は何ですか>))
* ((<FAQ::変数、定数、引数/2.10 仮引数にデフォルト値を指定できますか>))
* ((<FAQ::変数、定数、引数/2.11 ブロックに引数を渡すにはどうしますか>))
* ((<FAQ::変数、定数、引数/2.12 変数や定数の値が知らないうちに変化することがありますが>))
* ((<FAQ::変数、定数、引数/2.13 定数は変更されませんか>))

== 2.1 変数や定数への代入によりオブジェクトはコピーされますか

変数や定数は、あるオブジェクトを指しています。何も代入しなくても
nilオブジェクトを指しています。代入は、変数や定数が新しいオブジェクトを
指すようにします。

したがって、代入によりオブジェクトがコピーされて新しく作られることは
なく、右辺の表現の表しているオブジェクトを左辺の変数や定数が指すように
することが代入によって行われます。

という説明で満足していただければいいのですが、これでは満足できない
という方もいらっしゃるかもしれません。このような理解で問題が
生じることはないのですが、実は、((<Fixnum>))、((<NilClass>))、
((<TrueClass>))、((<FalseClass>)) および ((<Symbol>)) クラス
のインスタンスは、直接変数や定数が保持していますので、これらは
代入によってコピーされることになります。これら以外のクラスのインスタンスは
メモリの別の場所にあり、それを変数や定数が参照することになります。
((<即値と参照|FAQ::組み込みライブラリ>))を参照してください。

== 2.2 ローカル変数のスコープはどのように決められていますか

トップレベル、クラス(モジュール)定義、メソッド定義のそれぞれで
独立したスコープになっています。ブロック内では、新たなスコープが
導入されるとともに、外側のローカル変数を参照できます。

ブロック内が特別になっているのは、((<Thread>))や手続きオブジェクトの
中でローカル変数を局所化できるようにするためです。
(({while}))、(({until}))、(({for}))は制御構造であり、新しいスコープを
導入しません。
(({loop}))はメソッドで、後ろについているのはブロックです。

== 2.3 ローカル変数はいつ参照可能になるのでしょうか

Rubyスクリプトは、Rubyインタプリタに実行させようとすると、
まず最後まで一度読みこまれ、構文解析されます。構文上問題が生じなければ、
構文解析で作られた構文木が最初から実行に移されます。

ローカル変数が参照可能になるのは、この構文解析の時にローカル変数への
代入文が見つかった時です。

  for i in 1..2
    if i == 2
      print a
    else
      a = 1
    end
  end

test.rbというファイルにいれて、このスクリプトを実行すると、

  test.rb:3: undefined local variable or method `a' for
     #<Object:0x40101f4c> (NameError)
        from test.rb:1:in `each'
        from test.rb:1

ということで、(({i}))が1の時は、エラーが起こらず、(({i}))が2になった時に
エラーが起こります。構文解析の時には、最初の(({print a}))が実際には
(({a}))への代入が行われてから実行されるというところまで解析されず、
この文を構文解析する時までに(({a}))への代入文が現われていないので、
ローカル変数は参照されません。実行時には(({a}))というメソッドが
ないか探しますが、これも定義されていないのでエラーになります。

逆に、次のスクリプトは、エラーになりません。

  a = 1 if false; print a
  #=> nil


ローカル変数のこのような振舞いに悩まされないためには、ローカル変数が
参照される文より前に、(({a = nil})) といった代入文を置くことがすすめられて
います。こうすると、ローカル変数の参照が速くなるというおまけもついて
います。

== 2.4 定数のスコープはどのように決められていますか

クラス/モジュールで定義された定数は、そのクラス/モジュールの中で
参照できます。

クラス/モジュール定義がネストしている場合には、内側のクラス/モジュール
から外側の定数を参照できます。

またスーパークラス及びインクルードしたモジュールの定数を参照できます。

トップレベルで定義された定数は、((<Object>))クラスに追加されますので、
すべてのクラス/モジュールから参照できます。

直接参照できない定数は、(({::}))演算子を使って、クラス/モジュール名を
指定することにより参照できます。

== 2.5 実引数は仮引数にどのように渡されますか

実引数は、メソッド呼び出しによって仮引数に代入されます。Rubyにおける
代入の意味は、((<変数への代入|FAQ::変数、定数、引数>))を
参照してください。
実引数が参照しているオブジェクトが、自分の状態を変更するメソッドを
持っている時には、副作用(それが主作用かもしれませんが)に注意する
必要があります。((<破壊的メソッド|FAQ::メソッド>))参照。

== 2.6 仮引数に代入すると実引数に影響を及ぼしますか

仮引数は、ローカル変数であり、仮引数に代入を行うと他のオブジェクトを
指すようになるだけで、元の実引数のオブジェクトには何の影響もありません。

== 2.7 仮引数の指すオブジェクトにメッセージを送るとどうなりますか

仮引数の指すオブジェクトは、実引数の指しているオブジェクトですから、
そのメッセージによってオブジェクトの状態が変化する場合には、呼び出し側に
影響が及ぶことになります。((<破壊的メソッド|FAQ::メソッド>))参照。

== 2.8 (({*}))がついた引数は何ですか

Cウィザードのみなさん、これはポインタではありません。Rubyでは引数に
(({*}))を付けることで、不定個の引数を配列に格納した形で受け取ることがで
きます。

  def foo(*all)
    for e in all
      print e, " "
    end
  end

  foo(1, 2, 3)
  #=> 1 2 3

またメソッド呼び出しで(({*}))を付けた配列を渡すと配列を展開して渡すこと
ができます。

  a = [1, 2, 3]
  foo(*a)

現在、(({*}))をつけることができるのは

(1) 多重代入の左辺
(2) 多重代入の右辺
(3) 引数リスト(定義側)
(4) 引数リスト(呼び出し側)
(5) (({case}))の(({when}))節

の末尾だけです。(1)は

  x, *y = [7, 8, 9]

のような形式で、この場合 (({x = 7}))、(({y = [8, 9]})) になり
ます。

  x, = [7, 8, 9]

のような記述もでき、この場合、(({x = 7})) で

  x = [7, 8, 9]

なら、(({x = [7, 8, 9]})) になります。

== 2.9 (({&}))がついた引数は何ですか

手続きオブジェクトをブロックとして受け渡しするための引数です。
引数列の一番最後に置きます。

== 2.10 仮引数にデフォルト値を指定できますか

できます。

しかもこのデフォルト値は関数の呼び出し時に評価されます。Rubyのデフォル
ト値は任意の式が可能で(C++はコンパイル時に決まる定数のみ)、評価はメソッ
ドのスコープで呼び出し時に行われます。

== 2.11 ブロックに引数を渡すにはどうしますか

ブロックの先頭に、仮引数を||で囲って置くと、実引数が多重代入されます。
この仮引数は、普通のローカル変数で、ブロックの外側ですでに使われて
いる変数の場合は、そのスコープになりますので、注意が必要です。

== 2.12 変数や定数の値が知らないうちに変化することがありますが

次のような例でしょうか。

  A = a = b = "abc"; b << "d"; print a, " ", A
  #=> abcd abcd

変数や定数への代入は、オブジェクトを後でその変数や定数で参照する
ために用いられます。変数や定数にオブジェクトそのものが代入されて
いるのではなく、オブジェクトの参照を保持しているだけです。変数は、
この参照を変更して異なるオブジェクトを参照するようにすることが
できますが、定数では一度保持した参照を変更することができません。

変数や定数にメソッドを適用すると、そのメソッドは、変数や定数が
指しているオブジェクトに適用されます。上の例では、<<というメソッドが
オブジェクトの状態を変えてしまうために、「予期せぬ」結果が生まれて
います。オブジェクトが数値の場合には、数値の状態を変えるメソッドが
ないため、このような問題は生じません。数値にメソッドを適用した時には
新しいオブジェクトが返されます。

この例では、文字列で示しましたが、配列やハッシュなど、オブジェクトの
状態を変更するメソッドを持っているオブジェクトでも同様のことが起こり
得ます。

== 2.13 定数は変更されませんか

定数があるオブジェクトを指しているとき、別のオブジェクトを指すように
すると、warningが出ます。

そのオブジェクトが((<破壊的メソッド|FAQ::メソッド>))を持っていれば、オブジェクトの内容は変更できます。
