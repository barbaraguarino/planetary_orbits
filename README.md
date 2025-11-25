# Simulação de Órbitas Planetárias (N-Corpos)

Este projeto implementa uma simulação física de **N-Corpos** para modelar a interação gravitacional entre planetas. Desenvolvido em MATLAB/Octave, o sistema utiliza métodos numéricos para calcular órbitas precisas e gera animações 3D interativas.

O projeto foi estruturado separando a lógica de cálculo (física), a definição de dados (condições iniciais) e a visualização (animação), permitindo simulações e "replays" instantâneos.

---

## Funcionalidades

* **Motor Físico Preciso:** Utiliza o integrador **Leapfrog**, que conserva energia melhor que métodos tradicionais, garantindo órbitas estáveis por longos períodos.
* **Alta Performance:** Cálculos vetorizados para simular interações gravitacionais de todos-para-todos simultaneamente.
* **Arquitetura Desacoplada:** A simulação salva os dados em arquivos binários (`.bin`), permitindo que a animação seja reproduzida, pausada ou analisada posteriormente sem recalcular a física.
* **Visualização 3D:**
    * Rastros orbitais dinâmicos.
    * Zonas habitáveis (Quente, Habitável e Fria) opcionais.
    * Tamanhos e cores customizáveis baseados em dados reais ou gerados.
* **Cenários Prontos:** Inclui gerador de cenários hipotéticos (ex: Super Júpiter).

---

## 📂 Estrutura do Projeto

A organização segue a separação de responsabilidades:

```text
orbitas-planetas/
├── common/             # Núcleo da física (Integrador Leapfrog e Gravidade)
├── solar_system/       # Configurações reais (NASA) e animação específica do Sol
├── generic_system/     # Gerador de sistemas estelares aleatórios
├── data/               # Saída das simulações (arquivos .bin e .log)
├── simulation_examples/# Exemplos pré-calculados para apresentação
├── run_solar.m         # Script principal: Simulação do Sistema Solar
├── run_generic.m       # Script principal: Simulação Genérica
├── replay_solar.m      # Player para reproduzir simulações salvas
└── gen_scenarios.m     # Gerador de cenários extremos para demonstração
```

## Como Usar

### Pré-requisitos

MATLAB ou GNU Octave (versão 4.4+ recomendada para vecnorm).

Pacote qt para gráficos (padrão na maioria das instalações modernas do Octave).

1.  **Simulação do Sistema Solar**

    Para calcular a física e visualizar o Sistema Solar padrão:

    ```Matlab
    run_solar
    ```
    *Isso gerará os arquivos em data/simulacao_solar.bin.*

2. **Simulação Genérica**

    Para criar um sistema solar aleatório com 50 corpos:

    ```Matlab
    run_generic
    ```

3. **Modo Replay**

    Para apenas assistir a uma simulação já calculada (sem esperar o cálculo):

    ```Matlab
    % Toca a simulação padrão
    replay_solar

    % Toca um cenário específico (ex: Super Júpiter)
    replay_solar('super_jupiter')
    ```
    *O script busca automaticamente nas pastas simulation_examples e data.*

4. **Gerar Cenários Especiais**

    Para criar os arquivos de demonstração (Plutão Kamikaze, etc.):

    ```Matlab
    gen_scenarios
    ```
    *Isso preencherá a pasta simulation_examples com simulações de longa duração.*

## Detalhes Técnicos

### O Método Leapfrog

O método **Leapfrog** ("pula-cela") é utilizado por ser *simplético*, ou seja, ele preserva o volume no espaço de fase. Isso significa que a energia total do sistema (cinética + potencial) se mantém quase constante, evitando que a Terra espirale em direção ao Sol ou seja ejetada por erros numéricos.

* **Passo 1 (Drift):** Atualiza posição ($r_{t+\Delta t} = r_t + v_{t+0.5} \cdot \Delta t$)
* **Passo 2 (Kick):** Calcula forças e atualiza velocidade ($v_{t+1.5} = v_{t+0.5} + a(r_{t+\Delta t}) \cdot \Delta t$)

### Formato de Arquivos
* **`.bin` (Binário):** Contém as posições (X, Y, Z) de todos os corpos em *double precision*. Usado para leitura rápida durante a animação.
* **`.log` (Texto):** Metadados da execução.

## Autores

- Paulo Alves
- Pedro Sineiro
- Barbara Nascimento
- Pedro Muniz
