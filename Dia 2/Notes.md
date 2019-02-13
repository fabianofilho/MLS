
Problema?
    Principais razões pelas quais algoritmos às vezes não apresentam boa performance preditiva:
* Extrapolação inadequada dos resultados.
* Pré-processamento inadequado dos dados.
* Sobreajuste (mais importante).
* Validação inadequada da qualidade dos algoritmos.
EXTRAPOLAÇÃO INADEQUADA
• Desenvolver os algoritmos para uma população e esperar que funcionam corretamente para outra diferente.
• Importar algoritmos dos EUA/Europa: nossas características genéticas e socioeconômicas são muito diferentes.
• Extrapolação para períodos diferentes (cuidado com doenças sazonais).
PRÉ-PROCESSAMENTO INADEQUADO
Técnicas:
• Seleção das variáveis.
• Vazamento de dados.
• Padronização.
• Redução de dimensão.
• Colinearidade.
• Valores missing.
• One-hot encoding.
Seleção das variáveis
• Pré-selecionar variáveis que sejam preditoras plausíveis (bom senso do pesquisador).
• Coincidências acontecem em análises de big data e pode ser que o algoritmo dê muita importância para associações espúrias.
> Tylervigen.com (variáveis com variáveis que nao fazem sentido)

Vazamento de dados
“data leakage”.
- Acontece quando os dados de treino apresentam informação escondida que faz com que o modelo aprenda padrões que não são do seu interesse.
- Uma variável preditora tem escondida o resultado certo: Não é a variável que está predizendo o desfecho, mas o desfecho que está predizendo ela. 
Exemplo: Incluir o número identificador do paciente como variável preditora
(Se pacientes de hospital especializado em câncer tiverem números semelhantes. Se o objetivo for predizer câncer, algoritmo irá dar maior probabilidade a esses pacientes.
Esse algoritmo aprendeu algo interessante para o sistema de saúde?)
Motivo pelo qual os dados e os algoritmos de machine learning precisam ser abertos.
Watson prediz bem: mas é informação útil ou vazamento?

Padronização 
- A escala das variáveis pode afetar muito a qualidade das predições.
- Alguns algoritmos darão preferência para utilizar variáveis com valores muito alto.
Passar para score Z:
𝑧𝑖 = 𝑥𝑖 − 𝜇 
          𝜎
Zi = Xi-média(presente)/
          desvio padrão
Média = 0, DP = 1

Redução de dimensão 
Retirar variáveis que nao acha importante, se tiverem muitas importantes, reduzir em variáveis que capturam o máximo possível.
Pq? Quanto maior a dimensão dos dados (número de variáveis) maior o risco de o algoritmo encontrar e utilizar associações espúrias.
Como?
PCA (aprendizado nao supervisionado)
O objetivo é encontrar combinações lineares das variáveis preditoras que incluam a maior quantidade possível da variância original.
O primeiro componente principal irá preservar a maior combinação linear possível dos dados, o segundo a maior combinação linear possível não correlacionada com o primeiro componente, etc.

Colinearidade
Uma das razões pela qual a ACP é tão utilizada, é o fato de que cria componentes principais não correlacionados.
> Na prática, alguns algoritmos conseguem melhor performance preditiva com variáveis com baixa correlação.
Uma outra forma de diminuir a presença de variáveis com alta correlação é excluí-las.
- Variáveis colineares trazem informação redundante (tempo perdido).
- Além disso, aumentam a instabilidade dos modelos.
- Estabelecer um limite de correlação com alguma outra
variável (0,75 a 0,90).

Valores Missing
Na predição, gostamos de missing pelo fato de ter informação preditora…
Motivo sistemático -> INFORMAÇÃO PREDITIVA.
Grande diferença em relação a estudos de inferência, em que valores missing devem ser evitados.
Não conseguiu responder a uma pergunta sobre o seu passado -> INFORMAÇÃO PREDITIVA.
Pode ajudar na predição de problemas cognitivos graves no futuro.
>Em variáveis categóricas adicionar uma categoria para missing. 
> Imputação com machine learning ()
Ao predizer qual seria esse valor se ele existisse…
One-hot encoding 
Quando tem variáveis categóricas, e várias dentro destas…
Mesmo que avise a ele, acaba dando problema!!
Transformar categoria em variáveis (0,1,2)
Alguns algoritmos têm dificuldade em entender variáveis que têm mais do que uma categoria.
Acham que é uma variável contínua (0, 1, 2, 3…) — porém não têm significado contínuo.
A solução é transformar todas as categorias em uma variável diferente de valores 0 e 1 (one-hot encoding).
Variável com n categorias >— criadas n variáveis.
Pode trazer problemas em alguns modelos, como na regressão linear.
Solução: criar Dummies: n-1.
n-1 variáveis (deixar a mais frequente como categoria de referência). 
Problema: se usar interceptron, pode fazer matriz nao ficar inversível

SOBREAJUSTE*
Maior problema de Machine Learning
Não funciona bem no futuro pq os algorítmos decoraram os dados
Modelos muito complexos:
- Funcionam perfeitamente para a amostra em questão, mas não muito bem para amostras futuras.
- Dados influenciados por fatores aleatórios e erros de medida.

Como controlar? Fazer passar de Overfit -> Right -> Underfit
Correção humana!!!
Tradeoff entre viés e variância:
- Viés: erro gerado pelo uso de modelos para dados reais.
- Variância: quando pequenas mudanças nos dados levam a uma mudança muito grande nos parâmetros.
Modelo com alta variância e pouco viés
- 2 variáveis: linha que passa exatamente por todos os pontos.
- Se ajusta perfeitamente aos dados atuais, mas não aos futuros.
Modelo com baixa variância e alto viés
- 2 variáveis: linha reta para associação não-linear.
- Modelo simples, com baixo poder preditivo.
Como ve se ta com sobreajuste? Olha para o futuro.
Avaliar a performance preditiva do modelo em dados que não foram utilizados para definir o modelo.
- Se a performance preditiva cair muito com os novos dados: o modelo tem sobreajuste.
- É muito fácil ter boa predição nos dados que foram utilizados para definir o modelo: é só tornar o modelo muito complexo.
Soluções??
Utilizar dados do período seguinte.
- Exemplo: treinar o modelo em dados de 2016 e avaliar sua performance em dados de 2017.
- Problema: na maioria das vezes, os dados são coletados num mesmo período.
Separar os dados aleatoriamente em treino e teste.
Dados de “treino” (70-80%) são usados para definir o modelo e dados de “teste” (20-30%) são usados uma única vez para analisar a performance preditiva final dos modelos.
Usar uma única vez os dados de teste (testar qualidade, dados futuros).
Usar os dados de treino!! (senao volta o sobreajuste decorando o teste)
Para análises em que o desfecho a ser predito é uma categoria:
- Amostragem estratificada entre treino e teste.
- Manter mesma proporção do desfecho de interesse nos dois grupos.
Alguns algoritmos na prática conseguem melhor performance com distribuição igual entre as categorias: desfecho binário com 50% cada.
Soluções:
• Down-sampling: selecionar amostra da classe mais frequente até se igualar à menos frequente.
• Up-sampling: amostragem com reposição da classe menos frequente até se igualar à mais frequente.
• SMOTE: combinação de down e up-sampling.
Definir o modelo: é saber os parâmetros que o algoritmos sozinho aprende (ex: os deltas, estruturas das ávores), e os hiperparâmetros (definidos pelo pesquisador), em geral regularizados, forçando a ser mais simples para evitar sobreajuste.
Parecido com “podar a árvore”, nao deixando que ela fique muito longa.

VALIDAÇÃO INADEQUADA
faz validação cruzada
Treina em 9, testa em 1
Mesmos hiperparâmetros, treina aleatorio em 9, e em 1
