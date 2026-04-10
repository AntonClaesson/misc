---
title: "Source: Gemini Deep Research — RGB-IR Demosaicing"
type: source
tags:
  - imaging
  - rgb-ir
  - demosaicing
  - machine-vision
  - sensors
created: 2026-04-10
updated: 2026-04-10
sources:
  - gemini-deep-research-rgb-ir-demosaicing.md
---

# Source: Gemini Deep Research — RGB-IR Demosaicing

## Metadata

- **Author:** Repository owner (user-produced research)
- **Date:** 2026-04-10
- **Tool:** Google Gemini Deep Research
- **Format:** Long-form research article, not publicly published
- **Raw file:** `raw/gemini-deep-research-rgb-ir-demosaicing.md`

## Summary

- **RGB-IR sensors** multiplex visible and NIR pixels in a 4×4 CFA; dedicated IR pixels are ~25% of the array, so **native IR is always quarter-resolution** vs total megapixels.
- **Guided upscaling** exploits NIR leakage through RGB filter dyes to interpolate full-resolution IR, but efficacy **collapses under bright daylight** — visible saturation destroys IR SNR, and spectral decorrelation (Wood effect) makes RGB edges misleading for IR structure.
- In **active-IR / zero visible lux** scenarios, all RGB pixels act as NIR collectors, and effective IR resolution approaches **full sensor utilization** (~2.5 MP for 2.7 MP sensor; ~4.7–5.0 MP for 5 MP sensor).
- Under **mixed lighting**, the source argues a **~30% maximum quality gain** over native IR (linked to ~1.2–1.8 dB PSNR in GIRRE-class deep learning work); beyond that is **generative hallucination**, unacceptable for safety-critical applications (biometrics, ADAS, DMS).
- **5 MP RGB-IR** is characterized as operationally necessary for **>1 MP native IR in all conditions**; vendor examples include OmniVision OX05B1S (Nyxel, 36% QE @ 940 nm), Sony IMX775 (on-chip NIR subtraction + smart upscale), and ST VD1940/VB1943 (ASIL-B, on-chip smart upscale).

## Detailed Notes

### Signal model

Every RGB pixel accumulates both visible and NIR photons. The signal equation (visible integral + NIR integral) is the mathematical foundation for both the contamination problem and the guided upscaling opportunity. Longitudinal chromatic aberration limits how much sharp IR structure can actually be extracted from RGB pixels — NIR focuses at a different plane than visible light.

### Resolution math

The article rigorously defines **native** (physical pixel count per band) vs **effective** (equivalent monochrome resolving power after ISP processing) resolution. The 2.7 MP sensor's native 0.675 MP IR falls below 720p; the 5 MP sensor's native 1.25 MP IR exceeds it. This baseline gap is the core of the 5 MP argument.

### The ~30% cap derivation

Three converging lines:
1. **Empirical**: GIRRE and LapSRN-class methods yield ~1.2–1.8 dB PSNR gain, mapping to ~20–30% MTF improvement.
2. **Bayer analogy**: standard Bayer demosaicing already loses ~30% effective resolution vs monochrome — guided IR recovery cannot exceed what the demosaicing deficit itself costs.
3. **Information-theoretic**: cross-modal transfer hits asymptotic SSIM/PSNR limits because mutual information between visible and NIR spectra is fundamentally bounded.

### Vendor silicon strategies

All three profiled vendors (OmniVision, Sony, STMicro) embed ISP steps on-chip: NIR subtraction from RGB, upscaling, and reshuffling back to Bayer for downstream processing. This reflects an industry consensus that host-side processing adds too much latency and noise amplification.

## Pages Updated

- Created: [[RGB-IR Demosaicing]]
