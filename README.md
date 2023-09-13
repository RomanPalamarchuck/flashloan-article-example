# Flashloan Oracle Attack Demo using Hardhat

This repository contain a simplified example of a flashloan oracle attack leveraging code mentioned in relevant article. The primary purpose is to help understand the mechanics and potential vulnerabilities associated with flashloan-driven price manipulation.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)

## Overview

Flashloans provide the capability for users to borrow a significant amount of assets without collateral, given that the borrowed amount is returned within the same transaction. This can be exploited in certain circumstances to manipulate decentralized oracle prices, which can lead to arbitrage opportunities or other unintended consequences in DeFi protocols.

This repo contains:

- A simple Solidity contract that demonstrates how such an attack might be set up.

## Prerequisites

- [Node.js](https://nodejs.org/)
- [npm](https://www.npmjs.com/)

