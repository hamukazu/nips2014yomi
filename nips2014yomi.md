% A Safe Rule for Sparse Logistic Regression
% 加藤公一 (シルバーエッグテクノロジー株式会社)
% 2015/1/20 NIPS2014 読み会 (@ 東京大学工学部6号館)

## 自己紹介

加藤公一（かとうきみかず）

Twitter : @hamukazu

シルバーエッグテクノロジー株式会社所属

ショッピングサイト向けのレコメンデーションシステムのアルゴリズムを考えています。(ASPとして提供)

## この論文を選んだ動機

* 問題意識が一致
* Sparsenessはレコメンド業界でも重要
    - 計算量とか消費メモリとかの考慮
    - つまりサーバラックあたりにたくさんのサービスを詰め込みたい

## お断り

* 原論文は数学的な記述(定理・証明)が多いですが、それらはあまり説明しません。
* できるだけ概要を伝えるように努めます。

## Introduction

* Logistic Regression (LR, ロジスティック回帰)は主に二値分類に使われる手法
* モデルはベクトルによって表されるが、それが疎であると嬉しい。
    - 消費メモリのメリット
    - 計算速度のメリット
* 早い段階でどのパラメータがゼロかを決定できないだろうか？


## LR with L1 regularization

$$\min \frac{1}{m} \sum_{i=1}^{m} \bigl(1+\exp (-\beta^T x_i - b_ic)
 \bigr) + \lambda \Vert \beta \Vert_1 $$

* $\Vert\cdot\Vert_1$はL1ノルム($\Vert \beta\Vert :=\sum_{i=1}^{m} \lvert \beta \rvert)$
* $x_i\in \mathbb{R}^m, i=1,\ldots,p$：学習データの特徴ベクトル
* $b_i\in \left\{ -1,1 \right\},i=1,\ldots,p $：学習データのラベル
* $\beta \in \mathbb{R}^m, \ c\in \mathbb{R} $ ：(最適化すべき)パラメータ

## 双対問題への変換

$$\min \frac{1}{m} \sum_i \bigl(1+\exp (-\beta^T x_i - b_ic)
 \bigr) + \lambda \Vert \beta \Vert_1 $$

双対問題：

$$\min \left\{
g(\theta) = \frac{1}{m} \sum_{i=1}^m f(\theta_i): \lVert 
\bar{X}^T\theta\rVert_\infty,
\theta^T b=0, \theta \in \mathbb{R}^m
\right\}$$

ただし
$$ \bar{x}_i:= b_i x_i$$
つまり
$$ \bar{X}=b^T X$$

## Notations

学習の入力データ$X \in \mathrm{Mat}(m,p;\mathbb{R})$に対して、$x_i$は$i$行目のベクトル、$x^j$は$j$列目のベクトル。

$\lambda$に依存した最適値として、$\beta^{*}_\lambda$, $\theta^{*}_\lambda$

$\beta$の$i$番目の要素は$[\beta]_i$で表す。

## L1 regularizationとsparseness

* L1 regularization項がある最適化は解が疎であることが期待できる
* この場合も、KKT条件から次の式が得られる
$$\lvert \theta^{*T}_\lambda \bar{x}^j \rvert <m\lambda \Rightarrow [\beta_\lambda]_j=0$$
* 実際最適解の多くのパラメータが0になる。

## 既存研究

同じようにゼロ要素を先に見つける手法：

1. SAFE (El Ghaoui et al., 2010)
2. Strong rules (Tibshirani et al., 2012)
3. DOME (Xiang et al., 2012)

ここで、2.と3.はsafeではない(つまり最適解が0でない要素を0と判定することがある)。

本研究ではsafeかつ効率のよい手法を提案。

## 閾値について

$$ \mathcal{P}=\left\{ i|b_i=1\right\}, \mathcal{N}=\left\{i|b_i=-1\right\},
m^{+}=\#\mathcal{P}, m^{-}=\#\mathcal{N}$$
$$ \left[ \theta^{*}_{\lambda_{\max}} \right]_i =\left\{
\begin{array}{ll}
m^{-}/m & \text{if }i \in \mathcal{P}\\
m^{+}/m & \text{if }i \in \mathcal{N}
\end{array}\right.
$$
$$\lambda_{\max} = \frac{1}{m} \lVert X^T \theta_{\lambda^{*}_{\max}} \rVert_\infty$$

と定義すると次が成り立つ。

##

$\lambda > \lambda_{\max}$ならば$\beta^*_{\lambda}=0$かつ$\theta^*_{\lambda} = \theta^*_{\lambda_{\max}}$

つまり、ハイパーパラメータ$\lambda$が大きくなると$\beta^{*}_\lambda$がどんどん疎になっていき、ある閾値を超えると$\beta^*_\lambda=0$となり、このときの最適解は簡単に解析的に求めることができる。

## 条件の緩和

KKT条件により
$$\lvert \theta^{*T}_\lambda \bar{x}^j \rvert <m\lambda \Rightarrow [\beta_\lambda]_j=0$$
これを緩和し最適値$\theta^{*}_\lambda$が含まれるような領域を$\mathcal{A}_\lambda$とすると
$$\max_{\theta \in \mathcal{A}_\lambda} \lvert \theta^T \bar{x}^j \rvert <m\lambda \Rightarrow [\beta_\lambda]_j=0$$

方針：この条件を十分条件で簡略化していき、良いバウンドを見つける。

(途中計算略)

## 定理

$\lambda_{\max}\geq \lambda_0 > \lambda >0$のとき次のいずれかが成り立てば$\left[\beta^{*}_\lambda \right]_i=0$

1. $\bar{x}^j-\frac{\bar{x}^{jT}b}{\lVert b \rVert_2^2} b=0$
2. $max\left\{T_{\xi}(\theta^{*}_\lambda , \bar{x}^j ; \theta^{*}_{\lambda_0}) | \xi=\pm 1 \right\} <m\lambda$

ただし
$$T_\xi(\theta^{*}_\lambda , \bar{x}^j ; \theta^{*}_{\lambda_0}):=\max_{\theta \in \mathcal{A}_{\lambda_0}^\lambda} \xi \theta^T \bar{x}^j$$
$$\mathcal{A}_{\lambda_0}^\lambda:=
\left\{\theta | \lVert \theta - \theta^{*}_{\lambda_0} \rVert_2^2 \leq r^2, \theta^T b=0, \theta^T \bar{x}^{*}\leq m\lambda
\right\}$$

2.は凸最適化で、解析的な最適解(Theorem 8)が得られる。

実際の計算時には$\lambda_0=\lambda_{\max}$として計算してよい。

## といっても..

突然これだけ見せられても何を言ってるかわからないと思います。

でもとにかくバウンドできました！うれしい！

## 実験(1)
* 前立腺がんのデータを実験データとして使う
* SAFE, Strong Rule, Slores(=提案手法)を比較

## 実験結果(1)
最適化後に$0$になる要素のうち、あらかじめ$0$であると判定できたものの率

![(論文より抜粋)](fig1.eps)

## 実験(2)

* 実験データはニュースグループとYahoo!のカテゴリから
* あるカテゴリ（サブカテゴリ）をピックアップして、それに属すものと属さないものを、それぞれ同数になるようにランダムに抽出
* LRの最適化後に0なる要素のうち、どの程度あらかじめ除外できたかという割合と、計算時間を比較
* 既存手法のStrong Ruleと比較。
* (Strong rulesはsafeな手法ではないので、結果の正確さは提案手法の方が良いはず)

## 実験結果(2a)
あらかじめ$0$であると判定できたものの率
![(論文より抜粋)](fig2.eps)

## 実験結果(2b)
計算速度
![(論文より抜粋)](fig3.eps)

## 結論

* L1 regularized LRについて、最適解のゼロ要素をあらかじめ除外する手法を示し、その効率は既存手法を上回った
* Future work: LASSOやL1-reguralized SVMにも同じ考え方を適用したい。
