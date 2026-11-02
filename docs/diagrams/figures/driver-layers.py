"""The three layers of the driver: hardware-agnostic core, transport contracts, platform port.

Reads: From top to bottom. Your application talks to one ADS9324<Spi, Host> object, whose public methods are
listed from inc/ads9324.hpp. The core packs 24-bit register frames, selects register banks, merges the PGA
nibbles and unpacks conversion bursts. It reaches the hardware only through two CRTP contracts in
inc/ads9324_spi_interface.hpp: SpiInterface (one transfer method) and HostInterface (CONVST, DRDY and two
delays). The platform port is the only code you write: two small classes, or one class implementing both.
Below it is the hardware.
"""

import re
from pathlib import Path

from hardfoc_mkdocs_theme.figkit import Fig

ROOT = Path(__file__).resolve().parents[3]
DRIVER = "inc/ads9324.hpp"
COMM = "inc/ads9324_spi_interface.hpp"


def data():
    drv = (ROOT / DRIVER).read_text()
    public = drv[drv.index("class ADS9324 {"):drv.index("private:")]
    methods = []
    for name in re.findall(r"^\s+(?:\[\[nodiscard\]\]\s+)?(?:static constexpr\s+)?[\w:<>]+\s+([A-Z]\w+)\(", public, re.M):
        if name not in methods and name != "ADS9324" and not name.startswith("GetDriverVersion"):
            methods.append(name)
    comm = (ROOT / COMM).read_text()
    hooks = []
    for name in ("transfer", "ConvstWrite", "DrdyRead", "HasDrdy", "DelayUs", "DelayMs"):
        if re.search(rf"\b{name}\(", comm):
            hooks.append(name)
    return {
        "methods": methods,
        "port_hooks": hooks,
        "sources": [f"{DRIVER}:ADS9324 public methods", f"{COMM}:SpiInterface, HostInterface"],
    }


def build(d):
    f = Fig(
        "driver-layers",
        "Three layers, one of them yours",
        alt="Layer diagram: the application calls the hardware-agnostic ADS9324 driver and its methods, which use "
        "the SpiInterface and HostInterface contracts, which call the platform port you write, which drives the "
        "SPI bus, CONVST and DRDY of the ADS9324.",
        width=1200,
        kicker="Architecture",
        subtitle="The driver and the contracts are the same on every MCU. The port is one SPI transfer, two pins "
        "and two delays.",
        profile="overview",
        legend=[("brand", "this library"), ("teal", "you write"), ("slate", "hardware")],
    )
    W = f.body_w
    app = f.card(0, 0, W, "Your application", ["sampling loop, protection logic, data logger ..."], tone="slate")
    top = app.b + 40
    chips_h = f.chips(16, f.region_inner_top(top), W - 32, [m + "()" for m in d["methods"]], tone="brand")
    reg = f.region(0, top, W, f.region_inner_top(top) - top + chips_h + 18, "Hardware-agnostic core", tone="brand",
                   sub="ADS9324<Spi, Host>, inc/ads9324.hpp")
    comm = f.card(0, reg.b + 40, W, "Transport contracts",
                  ["SpiInterface: 24-bit register frames and conversion bursts, one CS window per call;",
                   "HostInterface: CONVST pulse, DRDY poll or timed wait, power-on and reset delays"],
                  tone="brand", accent=True)
    port = f.card(0, comm.b + 40, W, "Platform port (your classes)", ["  ".join(h + "()" for h in d["port_hooks"])],
                  tone="teal", accent=True, mono=True)
    hw = f.card(0, port.b + 40, W, "ADS9324",
                ["SPI mode 0 up to 60 MHz (SDI, SDOUT, SCLK, CS)  /  CONVST, DRDY/ALARM"], tone="slate")
    for a, b in ((app, reg), (reg, comm), (comm, port), (port, hw)):
        f.connect(a, b, "bottom", "top", tone="rail")
    return f
