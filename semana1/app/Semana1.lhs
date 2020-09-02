---
author: Programação Funcional
title: Exercícios para tutoria. Semana 1.
date: Prof. Rodrigo Ribeiro
---

> import Data.Char (isDigit, toLower, isLower)

Introdução
==========

Esse material consiste em exercícios sobre o conteúdo introdutório da
linguagem Haskell. Todos os exercícios envolvem problemas de cunho
matemático que servem para familiarizar o aluno com a sintaxe da linguagem,
o ambiente de programação (editor de texto favorito e interpretador GHCi)
e funções recursivas simples.

Antes de resolver os exercícios contidos nesse material, recomendo que você
faça todos os exercícios presentes nos slides das aulas:

- Primeiros passos em Haskell.
- Definindo funções simples.

Nos exercícios seguintes, você deve substituir as
chamadas para a função

> tODO :: a
> tODO = undefined

que interompe a execução do programa com uma
mensagem de erro, por código que implementa
as funcionalidades requeridas por cada exercício.

A seguinte função `main` é usada apenas para omitir
mensagens de erro do compilador de Haskell.
Você pode ignorá-la.

> main :: IO ()
> main = return ()

Recursão sobre inteiros
=======================

Exercício 1
-----------

Considere a seguinte função:

$$
f(n) = \left \{ \begin{array}{ll}
                   \frac{n}{2} & \text{se }n \text{é par.}\\
                   3n + 1      & \text{caso contrário.}\\
                \end{array}
       \right.
$$

Esta simples função é um componente de um problema em aberto
na matemática: Aplicações sucessivas dessa função eventualmente
atingem o valor 1.

Com base no apresentado, faça o que se pede:

a) Codifique a função

> next :: Int -> Int
> next n
>    | (mod n 2) == 0 = div n 2
>    | otherwise = 3*n+1

que implementação da função f(n) apresentada anteriormente.

b) Usando a definição de `next`, implemente a função

> steps :: Int -> Int
> steps n
>    | n == 1 = 1
>    | otherwise = steps(next n)

que retorna 1, caso o valor fornecido sobre entrada seja 1. Caso
contrário, `steps` é chamada recursivamente sobre o resultado de
aplicar a função `nexts` sobre o parâmetro da função `steps`.

c) Uma maneira de medir empiricamente o tempo de execução de funções é
utilizar um contador de chamadas recursivas. Modifique a implementação
da função `steps` (item - b) de forma que esta retorne um par contendo o
resultado de sua execução e o número de chamadas recursivas realizadas.

> stepsCounter :: Int -> (Int,Int)
> stepsCounter n = aux n 0
>    where 
>        aux n x
>          | n == 1 = (n , x)
>          | otherwise = aux (next n) (x+1)

Como convenção, considere que o primeiro componente do par retornado
armazena o resultado da função e o segundo o número de chamadas
recursivas.

d) Você deve ter observado que a função `steps` sempre retorna o número 1
como resultado. Modifique a implementação de `steps` de forma que esta
função retorne a sequência númerica gerada por chamadas recursivas até
obtero resultado final, o número 1.

> stepsList :: Int -> ([Int],Int)
> stepsList n = aux (n:[]) 0
>    where 
>        aux ns x
>          | last ns == 1 = (ns , x)
>          | otherwise = aux (ns ++ [next (last ns)]) (x+1)

Exercício 2
-----------

O algoritmo para cálculo do máximo divisor comum de dois inteiros
é definido pela seguinte função:

$$
gcd(a,b) = \left\{
             \begin{array}{ll}
                a & \text{se } b = 0\\
                gcd(b, a\:mod\: b) & \text{caso contrário}\\
             \end{array}
           \right .
$$

a) Implemente o algoritmo para cálculo do máximo divisor comum em Haskell:

> gcd' :: Int -> Int -> Int
> gcd' a 0 = a
> gcd' a b = gcd' b (mod a b)


b) Modifque a implementação da função `gcd` de forma a retornar o número
de chamadas recursivas realizadas.

> gcdCounter :: Int -> Int -> (Int, Int)
> gcdCounter a b = aux a b 0
>     where 
>         aux a 0 c = (a, c)
>         aux a b c = aux b (mod a b) (c+1)

Método de Newton.
=================

Os exercícios seguintes descrevem um conjunto
de funções para implementar o método de Newton
para cálculo da raiz quadrada de um número.

O método de Newton é uma função que a partir do
radicando (valor para o qual desejamos calcular a
raiz quadrada) e uma aproximação tenativa produz uma
nova aproximação do resultado da raiz quadrada para o
radicando em questão.

Exercício 1
-----------

Defina uma função chamada `average` que
calcula a média de dois valores 
fornecidos como parâmetro.

> average :: Double -> Double -> Double
> average a b = (a+b)/2 

Exercício 2
-----------

Dizemos que uma tentativa `guess` para
a raiz quadrada de `x` é válida se o valor
absoluto da diferença do quadrado de `guess`
e `x` for menor que 0.001.
Baseado nesse fato, implemente a função
`goodEnough` que verifica se uma tentativa
é boa o suficiente.

> goodEnough :: Double -> Double -> Bool
> goodEnough a b = abs((a**2) - b) < 0.001

Exercício 3
-----------

Método de Newton consiste em repetir
uma função de melhoria de resultado até
atingir uma determinada precisão. A melhoria
de uma tentativa é a média desse valor e o
resultado de dividir o radicando pela tentativa.

Implemente a função `improve` que a partir de uma
tentativa e do radicando retorna uma nova tentativa
como resultado.

> improve :: Double -> Double -> Double
> improve 0 b = b
> improve a b = b/a


Exercício 4
-----------

De posse das funções anteriores, podemos implementar o
método de Newton para cálculo da raiz quadrada de um número.
Para isso, defina a função

> sqrtIter :: Double -> Double -> Double
> sqrtIter a b 
>      | goodEnough a b == True = a
>      | otherwise = sqrtIter (average(improve (a) (b)) a) (b)

que a partir de uma tentativa e do radicando, testa se a tentativa
é atende a restrição de precisão (usando a função `goodEnough`). Caso
a tentativa não atenda a restrição, devemos executar `sqrtIter` usando
como nova tentativa o resultado de `improve` sobre a tentativa atual.

Exercício 5
-----------

O método de Newton para raízes cúbicas é baseado no fato de que se `y`
é uma aproximação da raiz cúbida de `x`, então uma aproximação melhor é
dada pela seguinte fórmula:

$$
\dfrac{\frac{x}{y^2} - 2y}{3}
$$

Implemente a função `cubicIter` que a partir de uma tentativa e do radicando
retorna uma aproximação para raiz cúbica do radicando considerando como
tolerância o valor 0.0001.

> cubicIter :: Double -> Double -> Double
> cubicIter y x
>     | abs((y**3) - x) < 0.0001 = y
>     | otherwise = cubicIter (aproximation y x) (x)

> aproximation :: Double -> Double -> Double
> aproximation 0 x = x
> aproximation y x = ((x/(y**2)) - (2*y))/3



List comprehensions
===================

Examples
-----------

Soma o quadrado de numeros impares da lista

> example1 :: Int 
> example1 = sum [x ^ 2 | x <- [1..20], odd x]

Converter string para minusculo

> toLowers :: String -> String
> toLowers xs = [toLower c | c <- xs]

> selectDigits :: String -> String
> selectDigits xs = [c | c <- xs, isDigit c]

Produt cartesiano de listas   

> (.*.) :: [a] -> [b] -> [(a,b)]
> xs .*. ys = [(x,y) | x <- xs, y <- ys]

Triplas pitagoricas
(x,y,z) é pitagorica se x² == y² + z²

> triples :: Int -> [(Int, Int, Int)]
> triples n 
>   = [(x,y,z) | x <- [1..n]
>              , y <- [1..n]
>              , z <- [1..n]
>              , (x ^ 2) == (y ^ 2) + (z ^ 2)
>   ]

Gerando numeros primos dentro de um intervalo

Determina primeiro os fatores 

> factors :: Int -> [Int]
> factors n = [x | x <- [1..n] , n `mod` x == 0]

Verifica se é primo

> prime :: Int -> Bool
> prime n = factors n == [1,n]

Numeros primos menores ou iguais a n

> primes :: Int -> [Int]
> primes m = [ x | x <- [1..m] , factors x == [1,x]]

Dobrar os elementos de uma lista

> doubleList :: [Int] -> [Int]
> doubleList []         = []
> doubleList (x : xs)   = 2 * x : doubleList xs

Negar os bools de uma lista

> notList :: [Bool] -> [Bool]
> notList []            = []
> notList (x : xs)      =  not x : notList xs

Aplicar funcao em cada um dos elementos da lista (ORDEM SUPERIOR)

> map' :: (a -> b) -> [a] -> [b]
> map' _ []             = []
> map' f (x : xs)        = f x : map' f xs 

> doubleList' xs
>  = map' double xs
>     where 
>         double x = 2 * x

> notList' xs
>   = map' negate xs
>      where
>        negate x = not x

FIltrar uma lista

Retornar Todos os Inteiros pares

> evens :: [Int] -> [Int]
> evens []          = []
> evens (x : xs)
>   | even x = x : evens xs
>   | otherwise = evens xs

Retornar todas as letras minusculas

> lowers :: String -> String
> lowers []             = []
> lowers (x : xs)
>   | isLower x = x : lowers xs
>   | otherwise = lowers xs

ORDEM SUPERIOR

> filter' :: (a -> Bool) -> [a] -> [a]
> filter' _ []              = []
> filter' f (x : xs)
>     | f x = x : filter' f xs
>     | otherwise = filter' f xs

> evens' = filter' even

> lowers' = filter' isLower

FUNÇÔES ANONIMAS

> doubleAll :: [Int] -> [Int]
> doubleAll xs = map (\ x -> 2 * x) xs
      
Exercício 1
-----------

A função `sum` calcula a soma de elementos presente em uma lista de números.
Usando a função `sum` e list comprehensions construa uma função que calcule
a soma dos quadrados dos primeiros `n` números inteiros, em que `n` é um
parâmetro da função.

> squareSum :: Int -> Int
> squareSum n = sum [ x ^ 2 | x <- [1..n]]

Exercício 2
-----------

Uma maneira de representar um plano de coordenadas de tamanho $m \times n$ é usando
uma lista de pares $(x,y)$ de números inteiros tais que $0\leq x \leq n$ e
$0 \leq y \leq m$. Usando list comprehension, construa a função

> grid :: Int -> Int -> [(Int,Int)]
> grid m n = [ (x, y) | x <- [0..n], y <- [0..m]] 

que retorna um plano de coordenadas de acordo com a descrição apresentada.

Exercício 3
-----------

O produto escalar de duas listas de inteiros de tamanho $n$ é definido como

$$
\sum_{k = 0}^{n - 1}(xs_k \times ys_k)
$$

em que $xs_k$ é o $k$-ésimo elemento da lista $xs$. Implemente a função

> scalarProduct :: [Int] -> [Int] -> Int
> scalarProduct xs ys = sum [xsk * ysk | (xsk, ysk) <- zip xs ys] 

que calcula o produto escalar de duas listas fornecidas como argumento.