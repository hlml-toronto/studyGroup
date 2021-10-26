---
title: Abstract Generator
subtitle: A Transformer for writing scientific abstracts

description: We create a transformer model able to write a scientific abstract given a short prompt.

people:
  - jeremy
  - matt
  - nava
  - tiantian

layout: project
last-updated: 2021-6-5
---

We are working on the implementation of a transformer for the purpose of text generation. Our goal is to create a transformer model able to write a full scientific abstract given a short prompt. We train this transformer on a subset of abstracts from the arXiv.

We split our approach into the following categories:

- Data Preparation
- Tokenization
- Architecture Design
- Training 
- Text Generation

Our github code can be found
[here](https://github.com/hlml-toronto/Abstract-generator).


### Data Preparation and Tokenization

...

### Architecture Design

The goal is to build a model which can take a stream of tokens, and returns a vocabulary-length vector **w** which represents the conditional distribution of the next word.  

<img style="float: right;" src="/img/projects/textgen/approach.jpg" alt="Model overview" width="1200px" align="center" style="padding:5px;">

In order to recurrently generate text, the model could in principle feed these prediction vectors back in as input. This idea drove the popularity of recurrent architecutres such as LSTMs for text generation and related tasks. 

However, non-recurrent architectures known as Transformers have recently demonstrated good results on various NLP tasks. We have opted to use a Transformer-like architecture for this project. 

### Training 

We used two approaches: SGD and Adam. 

- For SGD we tried both monotonic and cylic learning rate schedules (to explore different minima).
- For Adam we specifically used variation with weight-decay (AdamW) and used 

<img style="float: right;" src="/img/projects/textgen/training.png" alt="Training curves" width="1000px" align="center" style="padding:5px;">

Both schemes trained within a few hours on a single desktop GPU (~3 minutes per epoch). 
Note that AdamW trains quickly, but also overfits quickly as indicated by the diverging validation loss. 
SGD trains much slower, but is not as prone to overfit. 

### Text Generation

Given an input stream of tokens with some context length, the network will return a vector **w** of length V.

A naive approach to text generation is "greedy decoding" - just keep selecting the token with the largest weight. Unfortunately, this naive scheme often gets stuck repeating certain words or phrases depending on the initial condition and context length. 

A more flexible approach is to contruct a boltzmann distribution from the weights **w**, and sample from that (note that this distribution is what the transformer is attempting to fit during training). 
We now have an explicit probability vector **p** for the next word distribution. 

<img style="float: right;" src="/img/projects/textgen/generation.jpg" alt="Output probabilities" width="1200px" align="center" style="padding:5px;">

Note that this introduces a hyperparameter, $$ \beta B $$, which is sometimes called the inverse-temperature parameter. Why? 
As beta -> 0 everything "melts", with **p** limiting to a uniform distribution over the vocabulary.
On the other hand, when beta -> inf, **p** becomes sharply peaked at the most probable word, recovering greedy decoding. 
For intermediate beta we can have much more interesting text generation. 
