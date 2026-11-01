<?xml version='1.0' encoding='UTF-8' standalone='yes' ?>
<tagfile doxygen_version="1.10.0" doxygen_gitid="ebc57c6dd303a980bd19dd74b8b61c8f3f5180ca">
  <compound kind="file">
    <name>api_reference.md</name>
    <path>docs/</path>
    <filename>api__reference_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>cmake_integration.md</name>
    <path>docs/</path>
    <filename>cmake__integration_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>configuration.md</name>
    <path>docs/</path>
    <filename>configuration_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>examples.md</name>
    <path>docs/</path>
    <filename>examples_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>hardware_setup.md</name>
    <path>docs/</path>
    <filename>hardware__setup_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>index.md</name>
    <path>docs/</path>
    <filename>index_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>installation.md</name>
    <path>docs/</path>
    <filename>installation_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>pga_and_calibration.md</name>
    <path>docs/</path>
    <filename>pga__and__calibration_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>platform_integration.md</name>
    <path>docs/</path>
    <filename>platform__integration_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>quickstart.md</name>
    <path>docs/</path>
    <filename>quickstart_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>registers.md</name>
    <path>docs/</path>
    <filename>registers_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>troubleshooting.md</name>
    <path>docs/</path>
    <filename>troubleshooting_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>ads9324.hpp</name>
    <path>inc/</path>
    <filename>ads9324_8hpp.html</filename>
    <includes id="ads9324__config_8hpp" name="ads9324_config.hpp" local="yes" import="no" module="no" objc="no">ads9324_config.hpp</includes>
    <includes id="ads9324__registers_8hpp" name="ads9324_registers.hpp" local="yes" import="no" module="no" objc="no">ads9324_registers.hpp</includes>
    <includes id="ads9324__spi__interface_8hpp" name="ads9324_spi_interface.hpp" local="yes" import="no" module="no" objc="no">ads9324_spi_interface.hpp</includes>
    <includes id="ads9324__types_8hpp" name="ads9324_types.hpp" local="yes" import="no" module="no" objc="no">ads9324_types.hpp</includes>
    <includes id="ads9324_8ipp" name="ads9324.ipp" local="yes" import="no" module="no" objc="no">ads9324.ipp</includes>
    <class kind="class">ads9324::ADS9324</class>
    <namespace>ads9324</namespace>
    <member kind="define">
      <type>#define</type>
      <name>ADS9324_HEADER_INCLUDED</name>
      <anchorfile>ads9324_8hpp.html</anchorfile>
      <anchor>a44d1cb85fb44b3b89334e939838de66a</anchor>
      <arglist></arglist>
    </member>
    <docanchor file="ads9324_8hpp.html" title="Basic Usage">ads9324_hpp_usage</docanchor>
  </compound>
  <compound kind="file">
    <name>ads9324_config.hpp</name>
    <path>inc/</path>
    <filename>ads9324__config_8hpp.html</filename>
    <includes id="ads9324__types_8hpp" name="ads9324_types.hpp" local="yes" import="no" module="no" objc="no">ads9324_types.hpp</includes>
    <namespace>ADS9324_CFG</namespace>
  </compound>
  <compound kind="file">
    <name>ads9324_registers.hpp</name>
    <path>inc/</path>
    <filename>ads9324__registers_8hpp.html</filename>
    <includes id="ads9324__types_8hpp" name="ads9324_types.hpp" local="yes" import="no" module="no" objc="no">ads9324_types.hpp</includes>
    <namespace>ads9324</namespace>
    <namespace>ads9324::reg</namespace>
  </compound>
  <compound kind="file">
    <name>ads9324_spi_interface.hpp</name>
    <path>inc/</path>
    <filename>ads9324__spi__interface_8hpp.html</filename>
    <class kind="class">ads9324::SpiInterface</class>
    <class kind="class">ads9324::HostInterface</class>
    <namespace>ads9324</namespace>
  </compound>
  <compound kind="file">
    <name>ads9324_types.hpp</name>
    <path>inc/</path>
    <filename>ads9324__types_8hpp.html</filename>
    <class kind="struct">ads9324::ChannelConfig</class>
    <class kind="struct">ads9324::ReadResult</class>
    <class kind="struct">ads9324::Snapshot</class>
    <class kind="struct">ads9324::Diagnostics</class>
    <namespace>ads9324</namespace>
  </compound>
  <compound kind="file">
    <name>README.md</name>
    <path></path>
    <filename>README_8md.html</filename>
  </compound>
  <compound kind="file">
    <name>ads9324.ipp</name>
    <path>src/</path>
    <filename>ads9324_8ipp.html</filename>
    <namespace>ads9324</namespace>
  </compound>
  <compound kind="class">
    <name>ads9324::ADS9324</name>
    <filename>classads9324_1_1ADS9324.html</filename>
    <templarg>typename SpiType</templarg>
    <templarg>typename HostType</templarg>
    <member kind="function">
      <type></type>
      <name>ADS9324</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a43127874d75f50908586144a82223b71</anchor>
      <arglist>(SpiType &amp;spi, HostType &amp;host) noexcept</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>ADS9324</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a6e00dafe51f6b4c9b2920f599a6f72ca</anchor>
      <arglist>(const ADS9324 &amp;)=delete</arglist>
    </member>
    <member kind="function">
      <type>ADS9324 &amp;</type>
      <name>operator=</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a393c7552083bfd067670bb9bab81d8ee</anchor>
      <arglist>(const ADS9324 &amp;)=delete</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>EnsureInitialized</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a3bdb7ab99e9e4574cfd8e3cf356a71c0</anchor>
      <arglist>(bool force=false) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>IsInitialized</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a6bc84a5f505e3b2464d3aad2dee4644e</anchor>
      <arglist>() const noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SoftwareReset</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a83b147f2304c63657d46c04804db54a7</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function">
      <type>uint16_t</type>
      <name>ReadDeviceId</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a0233da0851b25dd1198bd80d9e271b51</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>ConfigureChannel</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>aaf9138970db8bc58dafa60fecf82d772</anchor>
      <arglist>(uint8_t channel, const ChannelConfig &amp;cfg) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>ConfigureAllChannels</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a66e04e758725f1173a9eda567a61ba9f</anchor>
      <arglist>(const ChannelConfig &amp;cfg) noexcept</arglist>
    </member>
    <member kind="function">
      <type>ChannelConfig</type>
      <name>GetChannelConfig</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a246bef0c4d7a4e5631a656948cfe51e8</anchor>
      <arglist>(uint8_t channel) const noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetChannelOffset</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a801515a5ce6b10b69a1c5fe295f6f4e9</anchor>
      <arglist>(uint8_t channel, int16_t ofs_10bit) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetChannelGain</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>aedf9976185a792afe1c7a283706a6c9d</anchor>
      <arglist>(uint8_t channel, uint16_t gan_14bit) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetDataFormat</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>af1e8e5d6442bf41c19ccd8ebb80e44a4</anchor>
      <arglist>(DataFormat format) noexcept</arglist>
    </member>
    <member kind="function">
      <type>DataFormat</type>
      <name>GetDataFormat</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a6363c9f97093d1ad1156fee2baa4ef91</anchor>
      <arglist>() const noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetDigitalInterface</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>af8a0a4af75f92d0e566a50be5cbd2b25</anchor>
      <arglist>(DoutLaneMode lanes, DoutLength length, bool data_on_sdout) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetChannelCountMode</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>adcde9d734a293e707245390ce0ea7a6a</anchor>
      <arglist>(ChannelCountMode mode, uint8_t ch_sel=0) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetPowerDown</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a75798ca2e80bfa00502e91d7d7f61d74</anchor>
      <arglist>(bool power_down) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>SetAlarmPin</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a7e9c0abd007056b022cf7135f0fda085</anchor>
      <arglist>(AlarmPinMode mode, bool active_low=false) noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>ProgramWindowComparator</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>ad32fc662c63ab9ef5f080331a97afb49</anchor>
      <arglist>(uint8_t channel, int8_t high_th, int8_t low_th, bool enable=true) noexcept</arglist>
    </member>
    <member kind="function">
      <type>Snapshot</type>
      <name>ReadSnapshot</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a6a094d0c2d499a51454fabd735e4e5dd</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function">
      <type>ReadResult</type>
      <name>ReadChannel</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>ab7e94abc00a4e547d983258b0f8135a8</anchor>
      <arglist>(uint8_t channel) noexcept</arglist>
    </member>
    <member kind="function">
      <type>float</type>
      <name>CountToVoltage</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a6a7aa405f3aef4e9e7b06bd4b0f397f6</anchor>
      <arglist>(uint8_t channel, int16_t twos) const noexcept</arglist>
    </member>
    <member kind="function">
      <type>Diagnostics</type>
      <name>GetDiagnostics</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a9611c79333da2ad13007d1485f7dccac</anchor>
      <arglist>() const noexcept</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static constexpr uint8_t</type>
      <name>GetDriverVersionMajor</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a5a0e8866c655c96121fef33150a64e82</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static constexpr uint8_t</type>
      <name>GetDriverVersionMinor</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a6c1dff4d242ffa1c1be5c47e83b8de50</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function" static="yes">
      <type>static constexpr uint8_t</type>
      <name>GetDriverVersionPatch</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a7982921e0a271de29671ef846bd027f0</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function" protection="private">
      <type>uint32_t</type>
      <name>spiTransfer24</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a07a57c6025d749a8991d803da5848d1e</anchor>
      <arglist>(uint32_t tx24) noexcept</arglist>
    </member>
    <member kind="function" protection="private">
      <type>bool</type>
      <name>writeRegister</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a3650ec2652187157fb3aae601b3ecabd</anchor>
      <arglist>(RegisterBank bank, uint8_t addr, uint16_t data) noexcept</arglist>
    </member>
    <member kind="function" protection="private">
      <type>bool</type>
      <name>readRegister</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>ada26d1861913e84af3baf5a80b09fe84</anchor>
      <arglist>(RegisterBank bank, uint8_t addr, uint16_t &amp;data) noexcept</arglist>
    </member>
    <member kind="function" protection="private">
      <type>bool</type>
      <name>selectBank</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a69b0319c935ba930f385a1e080d095bc</anchor>
      <arglist>(RegisterBank bank) noexcept</arglist>
    </member>
    <member kind="function" protection="private">
      <type>bool</type>
      <name>applyDigitalInterface</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a09aa0c7c1c5728452e70bc33577beaba</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function" protection="private">
      <type>bool</type>
      <name>pulseConvstAndWait</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a7b00dfc5a39f75e721733d9b694ce33a</anchor>
      <arglist>() noexcept</arglist>
    </member>
    <member kind="function" protection="private">
      <type>uint8_t</type>
      <name>activeChannelCount</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a2aba15c7763f579e62950979d00cfe0d</anchor>
      <arglist>() const noexcept</arglist>
    </member>
    <member kind="variable" protection="private">
      <type>SpiType &amp;</type>
      <name>spi_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a602d5682532f17ec77cc0862ffd48e50</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>HostType &amp;</type>
      <name>host_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>aeb15b9e2396f8ec054d75a5aa5dd3bdd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>bool</type>
      <name>initialized_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a5cca103a1def4348494604d2767d532c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>RegisterBank</type>
      <name>current_bank_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a7d8cfa97951226599b3dd7858ad22944</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>DataFormat</type>
      <name>format_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>af7fa065f4662c4a6892af019f912b4cc</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>DoutLaneMode</type>
      <name>lanes_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a67df97ee38aef88de63beaec730ac5ab</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>DoutLength</type>
      <name>length_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a90dd0a5b9545349bc67bdcfd9398c9cf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>bool</type>
      <name>data_on_sdout_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a8d09fcfe5b5283c1e6cdeff61df75831</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>ChannelCountMode</type>
      <name>ch_count_mode_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a26b12349d545336cf5a707cb361fab5d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>uint8_t</type>
      <name>ch_sel_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a90c762f41f398f745fae14b03ede5959</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>ChannelConfig</type>
      <name>ch_cfg_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a4ffef0bd709cfe70db4eb6400ef3d349</anchor>
      <arglist>[kNumChannels]</arglist>
    </member>
    <member kind="variable" protection="private">
      <type>uint32_t</type>
      <name>snapshots_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>a467748fbf09c2cb9a07f382109a053a4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable" protection="private">
      <type>uint32_t</type>
      <name>errors_</name>
      <anchorfile>classads9324_1_1ADS9324.html</anchorfile>
      <anchor>af194958a8cc5713834c39f912cc22099</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>ads9324::ChannelConfig</name>
    <filename>structads9324_1_1ChannelConfig.html</filename>
    <member kind="variable">
      <type>InputType</type>
      <name>type</name>
      <anchorfile>structads9324_1_1ChannelConfig.html</anchorfile>
      <anchor>a4d55a05e85aac36a8e507c53b25c30f8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>InputRange</type>
      <name>range</name>
      <anchorfile>structads9324_1_1ChannelConfig.html</anchorfile>
      <anchor>afb30b66faa245d76658fe65fab0f3cb6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>PgaBandwidth</type>
      <name>bandwidth</name>
      <anchorfile>structads9324_1_1ChannelConfig.html</anchorfile>
      <anchor>a9bd018fb7d88f5cf9f3f8df9cb583a31</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>common_mode_correct</name>
      <anchorfile>structads9324_1_1ChannelConfig.html</anchorfile>
      <anchor>a51790a4ded8831b563fc644320a58318</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>ads9324::Diagnostics</name>
    <filename>structads9324_1_1Diagnostics.html</filename>
    <member kind="variable">
      <type>bool</type>
      <name>initialized</name>
      <anchorfile>structads9324_1_1Diagnostics.html</anchorfile>
      <anchor>a106e3aed75ccaf368d0db65c259619ef</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>uint16_t</type>
      <name>device_id</name>
      <anchorfile>structads9324_1_1Diagnostics.html</anchorfile>
      <anchor>adecc62bf99b8f9383622b6e69d906299</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>DataFormat</type>
      <name>format</name>
      <anchorfile>structads9324_1_1Diagnostics.html</anchorfile>
      <anchor>a213e809bc97d0fbed69fcbb3188e5db1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>DoutLaneMode</type>
      <name>lanes</name>
      <anchorfile>structads9324_1_1Diagnostics.html</anchorfile>
      <anchor>ab362cfa5c9c7bda861c8328e31969f21</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>bool</type>
      <name>data_on_sdout</name>
      <anchorfile>structads9324_1_1Diagnostics.html</anchorfile>
      <anchor>a9288efddc263be9bdac91fa82b9565b1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>snapshots</name>
      <anchorfile>structads9324_1_1Diagnostics.html</anchorfile>
      <anchor>a89f7aa235842246f13f377e64749f9e2</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>uint32_t</type>
      <name>errors</name>
      <anchorfile>structads9324_1_1Diagnostics.html</anchorfile>
      <anchor>a6a8b7baf861f336c6a731d0163e2c4a9</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>ads9324::HostInterface</name>
    <filename>classads9324_1_1HostInterface.html</filename>
    <templarg>typename Derived</templarg>
    <member kind="function">
      <type>void</type>
      <name>ConvstWrite</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a4025bd3215844d81f14ddfc187400eaf</anchor>
      <arglist>(bool high)</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>DrdyRead</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a9f0792e222821f94038379393d958598</anchor>
      <arglist>()</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>HasDrdy</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>acf710cae6b48e70f36c0e7d3b86724fd</anchor>
      <arglist>() const</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>DelayUs</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>aeaf1823719c0c567788033b183e14dc4</anchor>
      <arglist>(uint32_t us)</arglist>
    </member>
    <member kind="function">
      <type>void</type>
      <name>DelayMs</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a0d2c8f6a5870cfbec1cc3985703b1e9b</anchor>
      <arglist>(uint32_t ms)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>HostInterface</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a99388e1373064e6ded8fae2a2e9002ab</anchor>
      <arglist>(const HostInterface &amp;)=delete</arglist>
    </member>
    <member kind="function">
      <type>HostInterface &amp;</type>
      <name>operator=</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a51a9cf9de0b15a6663ff2fb56d85cf37</anchor>
      <arglist>(const HostInterface &amp;)=delete</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>HostInterface</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>ac799d808f4e3389611bca25e641ec19a</anchor>
      <arglist>()=default</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>HostInterface</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a488a72755e52c513d880606c2962901a</anchor>
      <arglist>(HostInterface &amp;&amp;)=default</arglist>
    </member>
    <member kind="function" protection="protected">
      <type>HostInterface &amp;</type>
      <name>operator=</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a19701f288275abd57295643feaf330ef</anchor>
      <arglist>(HostInterface &amp;&amp;)=default</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>~HostInterface</name>
      <anchorfile>classads9324_1_1HostInterface.html</anchorfile>
      <anchor>a72d312815a4e62cb9c44c0ce3324d34c</anchor>
      <arglist>()=default</arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>ads9324::ReadResult</name>
    <filename>structads9324_1_1ReadResult.html</filename>
    <member kind="function">
      <type>bool</type>
      <name>ok</name>
      <anchorfile>structads9324_1_1ReadResult.html</anchorfile>
      <anchor>a94101679e92dbd0174f28dc807fdde08</anchor>
      <arglist>() const noexcept</arglist>
    </member>
    <member kind="variable">
      <type>uint8_t</type>
      <name>channel</name>
      <anchorfile>structads9324_1_1ReadResult.html</anchorfile>
      <anchor>a4d826b9b0e87a2f7ff533929041623ae</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>int16_t</type>
      <name>count</name>
      <anchorfile>structads9324_1_1ReadResult.html</anchorfile>
      <anchor>a0a6d9f886087764d477895493139a32e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>uint16_t</type>
      <name>raw</name>
      <anchorfile>structads9324_1_1ReadResult.html</anchorfile>
      <anchor>a1314ecc19ba241ffd1748b6d2e68641e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>float</type>
      <name>voltage</name>
      <anchorfile>structads9324_1_1ReadResult.html</anchorfile>
      <anchor>a8da23bacb52067bd47400d4944f14f49</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>Error</type>
      <name>error</name>
      <anchorfile>structads9324_1_1ReadResult.html</anchorfile>
      <anchor>a9eaa7fb242a28960292285126ec441a4</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="struct">
    <name>ads9324::Snapshot</name>
    <filename>structads9324_1_1Snapshot.html</filename>
    <member kind="function">
      <type>bool</type>
      <name>ok</name>
      <anchorfile>structads9324_1_1Snapshot.html</anchorfile>
      <anchor>ab23a8691c57520bebf5ea143aaffdfbf</anchor>
      <arglist>() const noexcept</arglist>
    </member>
    <member kind="function">
      <type>bool</type>
      <name>hasChannel</name>
      <anchorfile>structads9324_1_1Snapshot.html</anchorfile>
      <anchor>a310b2c3776868f77d41aa264c1b3e673</anchor>
      <arglist>(uint8_t ch) const noexcept</arglist>
    </member>
    <member kind="variable">
      <type>int16_t</type>
      <name>count</name>
      <anchorfile>structads9324_1_1Snapshot.html</anchorfile>
      <anchor>a711242d23807e17bdf4e8a44f0dbdcbb</anchor>
      <arglist>[kNumChannels]</arglist>
    </member>
    <member kind="variable">
      <type>float</type>
      <name>voltage</name>
      <anchorfile>structads9324_1_1Snapshot.html</anchorfile>
      <anchor>a06eb06953c7f524d10f268ccae9cb0a3</anchor>
      <arglist>[kNumChannels]</arglist>
    </member>
    <member kind="variable">
      <type>uint16_t</type>
      <name>valid_mask</name>
      <anchorfile>structads9324_1_1Snapshot.html</anchorfile>
      <anchor>a564e17780908d07259801081794c9ed6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>Error</type>
      <name>error</name>
      <anchorfile>structads9324_1_1Snapshot.html</anchorfile>
      <anchor>aaf96837a3b3175a313f1a5b0423ddde6</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="class">
    <name>ads9324::SpiInterface</name>
    <filename>classads9324_1_1SpiInterface.html</filename>
    <templarg>typename Derived</templarg>
    <member kind="function">
      <type>void</type>
      <name>transfer</name>
      <anchorfile>classads9324_1_1SpiInterface.html</anchorfile>
      <anchor>a49d3296857ad814181bda14162987317</anchor>
      <arglist>(const uint8_t *tx, uint8_t *rx, std::size_t len)</arglist>
    </member>
    <member kind="function">
      <type></type>
      <name>SpiInterface</name>
      <anchorfile>classads9324_1_1SpiInterface.html</anchorfile>
      <anchor>afb72ef13fd8e375df8f98bba9c837007</anchor>
      <arglist>(const SpiInterface &amp;)=delete</arglist>
    </member>
    <member kind="function">
      <type>SpiInterface &amp;</type>
      <name>operator=</name>
      <anchorfile>classads9324_1_1SpiInterface.html</anchorfile>
      <anchor>ac6e0e587ae50f2e1792d4da514f50bde</anchor>
      <arglist>(const SpiInterface &amp;)=delete</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>SpiInterface</name>
      <anchorfile>classads9324_1_1SpiInterface.html</anchorfile>
      <anchor>af782e3a1228d0e222719d621ec784bc9</anchor>
      <arglist>()=default</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>SpiInterface</name>
      <anchorfile>classads9324_1_1SpiInterface.html</anchorfile>
      <anchor>a0f636ef85d3d4832ce21ad6aed828e5c</anchor>
      <arglist>(SpiInterface &amp;&amp;)=default</arglist>
    </member>
    <member kind="function" protection="protected">
      <type>SpiInterface &amp;</type>
      <name>operator=</name>
      <anchorfile>classads9324_1_1SpiInterface.html</anchorfile>
      <anchor>a74bf36ec93671918aba0f4e08cc260b3</anchor>
      <arglist>(SpiInterface &amp;&amp;)=default</arglist>
    </member>
    <member kind="function" protection="protected">
      <type></type>
      <name>~SpiInterface</name>
      <anchorfile>classads9324_1_1SpiInterface.html</anchorfile>
      <anchor>a7acc5922c0f3a632d6300357f0ebf7c9</anchor>
      <arglist>()=default</arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>ads9324</name>
    <filename>namespaceads9324.html</filename>
    <namespace>ads9324::reg</namespace>
    <class kind="class">ads9324::ADS9324</class>
    <class kind="struct">ads9324::ChannelConfig</class>
    <class kind="struct">ads9324::Diagnostics</class>
    <class kind="class">ads9324::HostInterface</class>
    <class kind="struct">ads9324::ReadResult</class>
    <class kind="struct">ads9324::Snapshot</class>
    <class kind="class">ads9324::SpiInterface</class>
    <member kind="enumeration">
      <type></type>
      <name>Error</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga256d16221bb9600d49cf8696fb24b981</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981aa60852f204ed8028c1c58808b746d115">Ok</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a9646ad3a1c3e708b4fa8b4b4270fbab6">NotInitialized</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a94a9e4213f08b322090d83fa5a8be5e4">InvalidChannel</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a627251310d3384b591e4138be21145d5">InvalidParameter</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a4a9f044cba37c05b591c75f44fa85a8d">SpiError</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981ac85a251cc457840f1e032f1b733e9398">Timeout</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a47f039382b8a5c8b736d074eeb9568b5">DeviceIdMismatch</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a7c4c80b59e5b24866fe615278c460a34">ProgrammingFailed</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>RegisterBank</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga6e69dbed1deb94b92054a754ccbc7e99</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga6e69dbed1deb94b92054a754ccbc7e99ad13bc5b68b2bd9e18f29777db17cc563">Common</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga6e69dbed1deb94b92054a754ccbc7e99ac9ffd2a729d477e7f6d3a978c955689a">Ain1_8</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga6e69dbed1deb94b92054a754ccbc7e99aaf4f137559d64cb627a3486a4ce9e6fb">Ain9_16</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>InputType</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>gade2a89b324cf93eb684cf6b7da848517</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="ggade2a89b324cf93eb684cf6b7da848517a1c2eaa5d56340808f2a94368501e5496">Differential</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggade2a89b324cf93eb684cf6b7da848517a3bdea3ac1bbf38ef341bac5a9d204459">SingleEnded</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggade2a89b324cf93eb684cf6b7da848517a52e5c4ca81eb1cdb28ad8843dd8b7437">SingleEndedOpenWireSafe</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>InputRange</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga2a6d30ceba8afbdd813a66f420efb950</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a312630b83d61ddb33a79a05642b6056a">PlusMinus5V</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a68c5e2a26c07e2b9c87c95671df061ce">PlusMinus2V5</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a9fea4ad15c669a4f23c96f64e60b9a83">PlusMinus6V25</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a82832a1866ef98f4136351172693280d">PlusMinus10V</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a1fad528760804fd1809762ee6fd4cfb1">PlusMinus12V5</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>PgaBandwidth</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga9033c3e3f395dffc39d482e6a8a183d7</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga9033c3e3f395dffc39d482e6a8a183d7a28d0edd045e05cf5af64e35ae0c4c6ef">Low</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga9033c3e3f395dffc39d482e6a8a183d7ae7c770a61dbdf81ca922ae0260e327c1">Wide</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>DataFormat</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga93d444adecf648625a96f6a8f8034f1c</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga93d444adecf648625a96f6a8f8034f1ca870af7303a8bb73181a05007456fe8c3">TwosComplement</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga93d444adecf648625a96f6a8f8034f1ca135c1c45505fa8993a1f5886d15dd9f4">OffsetBinary</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>DoutLaneMode</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga3d68bd8146381223e0c566a13b810f7c</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca22404a3bc2ad541daf72d588b45e1675">Lanes8</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca5b484485cd450efa1c56ed77ff076745">Lanes4</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca8b1cfed334088cebed6962d4f4fb445f">Lanes2</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca039873655354962f4f47203c0e41b270">Lane1</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>DoutLength</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga9edd0724acec04ac077165aedf0f0240</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga9edd0724acec04ac077165aedf0f0240a02d5ba53dbd26550a12ad57f712d3b1f">Bits16</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga9edd0724acec04ac077165aedf0f0240ad3224fbe98dba768e889230f13416004">Bits24</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ChannelCountMode</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga4677915d8b01e413a9821b4bb1e26332</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332a2cf65ff356dc997d2e69f48f5110917b">All16</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332abaca0ca6729684fd54206793ae4b5bd5">Eight</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332a981b8fcee42e1e726a67a2b9a98ea6e9">Four</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332aaada29daee1d64ed0fe907043855cb7e">Two</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>AlarmPinMode</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>gab4063f7a93662164f80a5f223f1494aa</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaa2c93ba7b6490d3e1471085f102cd2a85">Drdy</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaab0ea5e65a0d31ca18146f60c7dc291af">DwcAlert</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaafff564d2618087c013167fa8e9927ad5">AdcCalDone</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaabb3b6ff87b45a175bc11196b14915891">OrMasked</enumvalue>
    </member>
    <member kind="function">
      <type>constexpr float</type>
      <name>FullScaleVolts</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga73999297919a825760d1d79fd7c479c3</anchor>
      <arglist>(InputRange range) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr float</type>
      <name>TwosToVoltage</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga2d574c1e1c024d9205d78935a67ae368</anchor>
      <arglist>(int16_t code, float full_scale) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr int16_t</type>
      <name>OffsetBinaryToTwos</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga4faf8ef305f335f798736a0efad23bc6</anchor>
      <arglist>(uint16_t raw) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr int16_t</type>
      <name>WireWordToTwos</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga5d909f9cd8244dc8246beeac7105360a</anchor>
      <arglist>(uint16_t raw, DataFormat format) noexcept</arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>kNumChannels</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga2791bb913c316d0af101a725dba58e02</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>kResolutionBits</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>gaeebd9f11900a85f9de4cf6ff62f71700</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>kMaxCountUnsigned</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga640730de795bd286978fcd4da80a73f5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>kDeviceIdAds9324</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga6edae771cdd164b99e85e832eba04fa2</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>ads9324::reg</name>
    <filename>namespaceads9324_1_1reg.html</filename>
    <member kind="function">
      <type>constexpr uint32_t</type>
      <name>PackWrite</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0431b9b236f3690cec8b4ee481637759</anchor>
      <arglist>(uint8_t addr, uint16_t data) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>UnpackRegData</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga3cd05bd8cf4ef52bd9a7813c3b1590f6</anchor>
      <arglist>(uint32_t rx24) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>ReadCommand</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga3fde7b05f599629fe20a0429d0d8db06</anchor>
      <arglist>(uint8_t addr) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>BankSelectValue</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0ef4855ccd6219f674fbb16b8fcb2c13</anchor>
      <arglist>(RegisterBank bank) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr RegisterBank</type>
      <name>BankForChannel</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga9103bd7e9bc10e638cd424d093877c18</anchor>
      <arglist>(uint8_t ch0) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>LocalChannel</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga25f7e6deee6960543a950157a999625b</anchor>
      <arglist>(uint8_t ch0) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>PgaConfigAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaac493870d42785dad944b3c0190fb021</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>OfsAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gac6c4d89905d83662dcf2c433dfeaddad</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>GanAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga78ceac077c0153fb69d9e7d9ff54d81e</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>DwcThAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gae341be979713d961299f49170db9bf43</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>EncodePgaNibble</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gada7ef0fd21990aca9375737e95546b74</anchor>
      <arglist>(const ChannelConfig &amp;cfg) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>GenCfg3Value</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gae1da9adc20525df40d07e8256d591e68</anchor>
      <arglist>(DoutLaneMode lanes, DoutLength length, bool data_on_sdout, DataFormat format) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>AnaCfg2Value</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaaccfd3e45b7c46b9e57a37e75661a11b</anchor>
      <arglist>(ChannelCountMode num, uint8_t ch_sel) noexcept</arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>kSpiFrameBytes</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gafd185d015b4d714d06e6dafe4b4e84eb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>kSpiFrameMask</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga2a1630407dcd5ccc59f8236d4d94111e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>GEN_CFG1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga71c11e80e42cbd20b96b4d5128e7ab2f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>BANK_SEL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga357b0b1e966ba6499dcd0d6b4934b72a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DIAG_CTRL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gac0d5cc1069e8584b4ed9c18bd10cf00c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>PDN_CTL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gad03cae55761ef38c945337a57a52e757</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>GEN_CFG2</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga27c89d4ef05b4c6bcdc93f3f079313ba</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>GEN_CFG3</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gac484d5a68a101ba375254173a8908a30</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>XOR_BITS_CTL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gacaf34b3c245026f1dff9d8056d68631b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DRDY_ALARM_SEL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga4dc6dd8034f2ffaa050a1820eae8f949</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>GEN_CFG4</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gad370f79707197921d95e72f667145561</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DIG_DELAY_CFG1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaf6d5ab8e247d37c3aeaff7487aef8992</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DIG_DELAY_CFG2</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga1268f357045d28c00b621cb525f67ef1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ANA_CFG1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gad1e3302a55386fd9fb93c31348149517</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ANA_CFG2</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaa367a1c7e44aa9ba07b739e39bb40532</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ADC_CAL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gabe2150a9fa50f065de00d6ba114c2a9e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DIG_FILTER</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga1bdfa3d6d7252544601d226de9696c4d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>GEN_CFG5</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga82430ad22e73dc3f4c22638cebef281d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DEVICE_STATUS</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga080ce7a175a05c3e55d354085dd13865</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DEVICE_ID</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga378f81a6d707ae894ed87c271fc26048</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>BANK_COMMON</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gabdcbb827d7f8e2604269b9f3abf3c00b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>BANK_AIN1_8</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga1d1b32d7eef4f323df398098c3031f4f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>BANK_AIN9_16</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga645426bb4089e80207b96f45bf47aeaf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>GEN_CFG1_SW_RST</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga38a38f4dcb79eb10618b10360dd6648e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>GEN_CFG1_REG_RD_EN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga90a0bfbfa52deb9bb5acea8d95f8f8bd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>PDN_CTL_DEVICE_PDN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga04a7705b85f0a7d090656d1f343ebc99</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>GEN_CFG3_1LANE_SDOUT_16B</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga4f7e12534760e244f70b345efdc2fb1d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>GEN_CFG3_EN_OFS_BINARY</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0766ffbb92123cf5119b8336b5530f60</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>GEN_CFG3_EN_DIAG_FLAG</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0cc6cf4aa830ea73c91f43bf1b7eb4f0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>GEN_CFG3_ADC_DATA_SDOUT_EN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga58611c0cb2f04556010fb6acdad085fd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ANA_CFG1_REFSEL_CTRL_DIS</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gae5269f7b1d241d39dedf0dc72686db4a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ANA_CFG1_EXT_REF_EN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga786cccd88eeda1c1fae57ba89af666dd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>DEVICE_STATUS_CALIB_BUSY</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaecc6d8a5422ce6c09c33d53080157aca</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>PGA_CONFIG_AIN12</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaedeaa9329d99f67d11c3bd054715e5b6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>PGA_BW_SEL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0a5090ba9368d5be6ab59934e4de17da</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>PHASE_DELAY_12</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga3506a49bab9319094b068612a4002b99</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>OFS_AIN1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga2d978347d52cfd7fff7526fd87c1c4d8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>GAN_AIN1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga6f7b85b28a29c2cabcb2576bcb5ef054</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DWC_CFG</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gacb02c264ed57b7e1e5142fdaff268d77</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DWC_TH_AIN1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaa9e1d1993893f58b318b83e0c3531c57</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>DWC_HYS_12</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaaf397cef7edbff2f00e878e98e7f8c9f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>DWC_CFG_STAT_RST</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga65333d3228d5e06add325f363922362e</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="namespace">
    <name>ADS9324_CFG</name>
    <filename>namespaceADS9324__CFG.html</filename>
    <member kind="variable">
      <type>constexpr ads9324::InputRange</type>
      <name>DEFAULT_RANGE</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga3aac6593526bae4fe57775c503321dd7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::InputType</type>
      <name>DEFAULT_INPUT_TYPE</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga34185100a6f92271b609bc83c7273111</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::PgaBandwidth</type>
      <name>DEFAULT_BANDWIDTH</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga15b8d796d435aad51622b94f78819a39</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::DataFormat</type>
      <name>DEFAULT_FORMAT</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga04edfb74d33957dd6e718484d6ce4550</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr bool</type>
      <name>REQUIRE_DEVICE_ID</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>gad9f07d88ebff4ebd7033db780efb12f8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>POWER_ON_DELAY_MS</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga13eee6a141fa36bcc3a7b231958c7ec4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>RESET_DELAY_MS</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>gaf1669cd5153e1ab355fc56f675233946</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>DRDY_TIMEOUT_US</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>gaa01a0f64147ff27cda438273ef0e8cc6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>CONV_FALLBACK_US</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga5c8d275e7dadf75092f2dff4170a00c0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::DoutLaneMode</type>
      <name>DEFAULT_LANES</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga69fa025904976954ba006a442fdacd84</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::DoutLength</type>
      <name>DEFAULT_LENGTH</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga100051c01ff2ec8bc681142eb556b8de</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr bool</type>
      <name>DEFAULT_DATA_ON_SDOUT</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga959846dda02db0dbcbcdc1f5dbc47b05</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="group">
    <name>ads9324_driver</name>
    <title>ADS9324 Driver</title>
    <filename>group__ads9324__driver.html</filename>
    <subgroup>ads9324_core</subgroup>
    <subgroup>ads9324_config</subgroup>
    <subgroup>ads9324_registers</subgroup>
    <subgroup>ads9324_transport</subgroup>
    <subgroup>ads9324_types</subgroup>
    <file>ads9324.hpp</file>
  </compound>
  <compound kind="group">
    <name>ads9324_core</name>
    <title>Core Driver API</title>
    <filename>group__ads9324__core.html</filename>
    <file>ads9324.ipp</file>
    <class kind="class">ads9324::ADS9324</class>
  </compound>
  <compound kind="group">
    <name>ads9324_config</name>
    <title>Compile-Time Configuration</title>
    <filename>group__ads9324__config.html</filename>
    <file>ads9324_config.hpp</file>
    <member kind="variable">
      <type>constexpr ads9324::InputRange</type>
      <name>ADS9324_CFG::DEFAULT_RANGE</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga3aac6593526bae4fe57775c503321dd7</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::InputType</type>
      <name>ADS9324_CFG::DEFAULT_INPUT_TYPE</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga34185100a6f92271b609bc83c7273111</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::PgaBandwidth</type>
      <name>ADS9324_CFG::DEFAULT_BANDWIDTH</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga15b8d796d435aad51622b94f78819a39</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::DataFormat</type>
      <name>ADS9324_CFG::DEFAULT_FORMAT</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga04edfb74d33957dd6e718484d6ce4550</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr bool</type>
      <name>ADS9324_CFG::REQUIRE_DEVICE_ID</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>gad9f07d88ebff4ebd7033db780efb12f8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>ADS9324_CFG::POWER_ON_DELAY_MS</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga13eee6a141fa36bcc3a7b231958c7ec4</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>ADS9324_CFG::RESET_DELAY_MS</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>gaf1669cd5153e1ab355fc56f675233946</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>ADS9324_CFG::DRDY_TIMEOUT_US</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>gaa01a0f64147ff27cda438273ef0e8cc6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>ADS9324_CFG::CONV_FALLBACK_US</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga5c8d275e7dadf75092f2dff4170a00c0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::DoutLaneMode</type>
      <name>ADS9324_CFG::DEFAULT_LANES</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga69fa025904976954ba006a442fdacd84</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr ads9324::DoutLength</type>
      <name>ADS9324_CFG::DEFAULT_LENGTH</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga100051c01ff2ec8bc681142eb556b8de</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr bool</type>
      <name>ADS9324_CFG::DEFAULT_DATA_ON_SDOUT</name>
      <anchorfile>group__ads9324__config.html</anchorfile>
      <anchor>ga959846dda02db0dbcbcdc1f5dbc47b05</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="group">
    <name>ads9324_registers</name>
    <title>Register and Frame Constants</title>
    <filename>group__ads9324__registers.html</filename>
    <file>ads9324_registers.hpp</file>
    <member kind="function">
      <type>constexpr uint32_t</type>
      <name>ads9324::reg::PackWrite</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0431b9b236f3690cec8b4ee481637759</anchor>
      <arglist>(uint8_t addr, uint16_t data) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::UnpackRegData</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga3cd05bd8cf4ef52bd9a7813c3b1590f6</anchor>
      <arglist>(uint32_t rx24) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::ReadCommand</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga3fde7b05f599629fe20a0429d0d8db06</anchor>
      <arglist>(uint8_t addr) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::BankSelectValue</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0ef4855ccd6219f674fbb16b8fcb2c13</anchor>
      <arglist>(RegisterBank bank) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr RegisterBank</type>
      <name>ads9324::reg::BankForChannel</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga9103bd7e9bc10e638cd424d093877c18</anchor>
      <arglist>(uint8_t ch0) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::LocalChannel</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga25f7e6deee6960543a950157a999625b</anchor>
      <arglist>(uint8_t ch0) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::PgaConfigAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaac493870d42785dad944b3c0190fb021</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::OfsAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gac6c4d89905d83662dcf2c433dfeaddad</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::GanAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga78ceac077c0153fb69d9e7d9ff54d81e</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DwcThAddr</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gae341be979713d961299f49170db9bf43</anchor>
      <arglist>(uint8_t local) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::EncodePgaNibble</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gada7ef0fd21990aca9375737e95546b74</anchor>
      <arglist>(const ChannelConfig &amp;cfg) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::GenCfg3Value</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gae1da9adc20525df40d07e8256d591e68</anchor>
      <arglist>(DoutLaneMode lanes, DoutLength length, bool data_on_sdout, DataFormat format) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::AnaCfg2Value</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaaccfd3e45b7c46b9e57a37e75661a11b</anchor>
      <arglist>(ChannelCountMode num, uint8_t ch_sel) noexcept</arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::kSpiFrameBytes</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gafd185d015b4d714d06e6dafe4b4e84eb</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint32_t</type>
      <name>ads9324::reg::kSpiFrameMask</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga2a1630407dcd5ccc59f8236d4d94111e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::GEN_CFG1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga71c11e80e42cbd20b96b4d5128e7ab2f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::BANK_SEL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga357b0b1e966ba6499dcd0d6b4934b72a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DIAG_CTRL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gac0d5cc1069e8584b4ed9c18bd10cf00c</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::PDN_CTL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gad03cae55761ef38c945337a57a52e757</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::GEN_CFG2</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga27c89d4ef05b4c6bcdc93f3f079313ba</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::GEN_CFG3</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gac484d5a68a101ba375254173a8908a30</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::XOR_BITS_CTL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gacaf34b3c245026f1dff9d8056d68631b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DRDY_ALARM_SEL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga4dc6dd8034f2ffaa050a1820eae8f949</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::GEN_CFG4</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gad370f79707197921d95e72f667145561</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DIG_DELAY_CFG1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaf6d5ab8e247d37c3aeaff7487aef8992</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DIG_DELAY_CFG2</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga1268f357045d28c00b621cb525f67ef1</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::ANA_CFG1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gad1e3302a55386fd9fb93c31348149517</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::ANA_CFG2</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaa367a1c7e44aa9ba07b739e39bb40532</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::ADC_CAL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gabe2150a9fa50f065de00d6ba114c2a9e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DIG_FILTER</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga1bdfa3d6d7252544601d226de9696c4d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::GEN_CFG5</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga82430ad22e73dc3f4c22638cebef281d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DEVICE_STATUS</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga080ce7a175a05c3e55d354085dd13865</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DEVICE_ID</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga378f81a6d707ae894ed87c271fc26048</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::BANK_COMMON</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gabdcbb827d7f8e2604269b9f3abf3c00b</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::BANK_AIN1_8</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga1d1b32d7eef4f323df398098c3031f4f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::BANK_AIN9_16</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga645426bb4089e80207b96f45bf47aeaf</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::GEN_CFG1_SW_RST</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga38a38f4dcb79eb10618b10360dd6648e</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::GEN_CFG1_REG_RD_EN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga90a0bfbfa52deb9bb5acea8d95f8f8bd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::PDN_CTL_DEVICE_PDN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga04a7705b85f0a7d090656d1f343ebc99</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::GEN_CFG3_1LANE_SDOUT_16B</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga4f7e12534760e244f70b345efdc2fb1d</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::GEN_CFG3_EN_OFS_BINARY</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0766ffbb92123cf5119b8336b5530f60</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::GEN_CFG3_EN_DIAG_FLAG</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0cc6cf4aa830ea73c91f43bf1b7eb4f0</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::GEN_CFG3_ADC_DATA_SDOUT_EN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga58611c0cb2f04556010fb6acdad085fd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::ANA_CFG1_REFSEL_CTRL_DIS</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gae5269f7b1d241d39dedf0dc72686db4a</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::ANA_CFG1_EXT_REF_EN</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga786cccd88eeda1c1fae57ba89af666dd</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::DEVICE_STATUS_CALIB_BUSY</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaecc6d8a5422ce6c09c33d53080157aca</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::PGA_CONFIG_AIN12</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaedeaa9329d99f67d11c3bd054715e5b6</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::PGA_BW_SEL</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga0a5090ba9368d5be6ab59934e4de17da</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::PHASE_DELAY_12</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga3506a49bab9319094b068612a4002b99</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::OFS_AIN1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga2d978347d52cfd7fff7526fd87c1c4d8</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::GAN_AIN1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga6f7b85b28a29c2cabcb2576bcb5ef054</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DWC_CFG</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gacb02c264ed57b7e1e5142fdaff268d77</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DWC_TH_AIN1</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaa9e1d1993893f58b318b83e0c3531c57</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::reg::DWC_HYS_12</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>gaaf397cef7edbff2f00e878e98e7f8c9f</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::reg::DWC_CFG_STAT_RST</name>
      <anchorfile>group__ads9324__registers.html</anchorfile>
      <anchor>ga65333d3228d5e06add325f363922362e</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="group">
    <name>ads9324_transport</name>
    <title>Transport Abstraction</title>
    <filename>group__ads9324__transport.html</filename>
    <file>ads9324_spi_interface.hpp</file>
    <class kind="class">ads9324::SpiInterface</class>
    <class kind="class">ads9324::HostInterface</class>
  </compound>
  <compound kind="group">
    <name>ads9324_types</name>
    <title>Driver Types</title>
    <filename>group__ads9324__types.html</filename>
    <file>ads9324_types.hpp</file>
    <class kind="struct">ads9324::ChannelConfig</class>
    <class kind="struct">ads9324::ReadResult</class>
    <class kind="struct">ads9324::Snapshot</class>
    <class kind="struct">ads9324::Diagnostics</class>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::Error</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga256d16221bb9600d49cf8696fb24b981</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981aa60852f204ed8028c1c58808b746d115">Ok</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a9646ad3a1c3e708b4fa8b4b4270fbab6">NotInitialized</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a94a9e4213f08b322090d83fa5a8be5e4">InvalidChannel</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a627251310d3384b591e4138be21145d5">InvalidParameter</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a4a9f044cba37c05b591c75f44fa85a8d">SpiError</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981ac85a251cc457840f1e032f1b733e9398">Timeout</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a47f039382b8a5c8b736d074eeb9568b5">DeviceIdMismatch</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga256d16221bb9600d49cf8696fb24b981a7c4c80b59e5b24866fe615278c460a34">ProgrammingFailed</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::RegisterBank</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga6e69dbed1deb94b92054a754ccbc7e99</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga6e69dbed1deb94b92054a754ccbc7e99ad13bc5b68b2bd9e18f29777db17cc563">Common</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga6e69dbed1deb94b92054a754ccbc7e99ac9ffd2a729d477e7f6d3a978c955689a">Ain1_8</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga6e69dbed1deb94b92054a754ccbc7e99aaf4f137559d64cb627a3486a4ce9e6fb">Ain9_16</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::InputType</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>gade2a89b324cf93eb684cf6b7da848517</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="ggade2a89b324cf93eb684cf6b7da848517a1c2eaa5d56340808f2a94368501e5496">Differential</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggade2a89b324cf93eb684cf6b7da848517a3bdea3ac1bbf38ef341bac5a9d204459">SingleEnded</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggade2a89b324cf93eb684cf6b7da848517a52e5c4ca81eb1cdb28ad8843dd8b7437">SingleEndedOpenWireSafe</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::InputRange</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga2a6d30ceba8afbdd813a66f420efb950</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a312630b83d61ddb33a79a05642b6056a">PlusMinus5V</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a68c5e2a26c07e2b9c87c95671df061ce">PlusMinus2V5</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a9fea4ad15c669a4f23c96f64e60b9a83">PlusMinus6V25</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a82832a1866ef98f4136351172693280d">PlusMinus10V</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga2a6d30ceba8afbdd813a66f420efb950a1fad528760804fd1809762ee6fd4cfb1">PlusMinus12V5</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::PgaBandwidth</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga9033c3e3f395dffc39d482e6a8a183d7</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga9033c3e3f395dffc39d482e6a8a183d7a28d0edd045e05cf5af64e35ae0c4c6ef">Low</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga9033c3e3f395dffc39d482e6a8a183d7ae7c770a61dbdf81ca922ae0260e327c1">Wide</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::DataFormat</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga93d444adecf648625a96f6a8f8034f1c</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga93d444adecf648625a96f6a8f8034f1ca870af7303a8bb73181a05007456fe8c3">TwosComplement</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga93d444adecf648625a96f6a8f8034f1ca135c1c45505fa8993a1f5886d15dd9f4">OffsetBinary</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::DoutLaneMode</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga3d68bd8146381223e0c566a13b810f7c</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca22404a3bc2ad541daf72d588b45e1675">Lanes8</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca5b484485cd450efa1c56ed77ff076745">Lanes4</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca8b1cfed334088cebed6962d4f4fb445f">Lanes2</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga3d68bd8146381223e0c566a13b810f7ca039873655354962f4f47203c0e41b270">Lane1</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::DoutLength</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga9edd0724acec04ac077165aedf0f0240</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga9edd0724acec04ac077165aedf0f0240a02d5ba53dbd26550a12ad57f712d3b1f">Bits16</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga9edd0724acec04ac077165aedf0f0240ad3224fbe98dba768e889230f13416004">Bits24</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::ChannelCountMode</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga4677915d8b01e413a9821b4bb1e26332</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332a2cf65ff356dc997d2e69f48f5110917b">All16</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332abaca0ca6729684fd54206793ae4b5bd5">Eight</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332a981b8fcee42e1e726a67a2b9a98ea6e9">Four</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="gga4677915d8b01e413a9821b4bb1e26332aaada29daee1d64ed0fe907043855cb7e">Two</enumvalue>
    </member>
    <member kind="enumeration">
      <type></type>
      <name>ads9324::AlarmPinMode</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>gab4063f7a93662164f80a5f223f1494aa</anchor>
      <arglist></arglist>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaa2c93ba7b6490d3e1471085f102cd2a85">Drdy</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaab0ea5e65a0d31ca18146f60c7dc291af">DwcAlert</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaafff564d2618087c013167fa8e9927ad5">AdcCalDone</enumvalue>
      <enumvalue file="group__ads9324__types.html" anchor="ggab4063f7a93662164f80a5f223f1494aaabb3b6ff87b45a175bc11196b14915891">OrMasked</enumvalue>
    </member>
    <member kind="function">
      <type>constexpr float</type>
      <name>ads9324::FullScaleVolts</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga73999297919a825760d1d79fd7c479c3</anchor>
      <arglist>(InputRange range) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr float</type>
      <name>ads9324::TwosToVoltage</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga2d574c1e1c024d9205d78935a67ae368</anchor>
      <arglist>(int16_t code, float full_scale) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr int16_t</type>
      <name>ads9324::OffsetBinaryToTwos</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga4faf8ef305f335f798736a0efad23bc6</anchor>
      <arglist>(uint16_t raw) noexcept</arglist>
    </member>
    <member kind="function">
      <type>constexpr int16_t</type>
      <name>ads9324::WireWordToTwos</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga5d909f9cd8244dc8246beeac7105360a</anchor>
      <arglist>(uint16_t raw, DataFormat format) noexcept</arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::kNumChannels</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga2791bb913c316d0af101a725dba58e02</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint8_t</type>
      <name>ads9324::kResolutionBits</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>gaeebd9f11900a85f9de4cf6ff62f71700</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::kMaxCountUnsigned</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga640730de795bd286978fcd4da80a73f5</anchor>
      <arglist></arglist>
    </member>
    <member kind="variable">
      <type>constexpr uint16_t</type>
      <name>ads9324::kDeviceIdAds9324</name>
      <anchorfile>group__ads9324__types.html</anchorfile>
      <anchor>ga6edae771cdd164b99e85e832eba04fa2</anchor>
      <arglist></arglist>
    </member>
  </compound>
  <compound kind="page">
    <name>md_docs_2api__reference</name>
    <title>API reference</title>
    <filename>md_docs_2api__reference.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2cmake__integration</name>
    <title>CMake</title>
    <filename>md_docs_2cmake__integration.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2configuration</name>
    <title>Configuration</title>
    <filename>md_docs_2configuration.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2examples</name>
    <title>Examples</title>
    <filename>md_docs_2examples.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2hardware__setup</name>
    <title>Hardware setup</title>
    <filename>md_docs_2hardware__setup.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2index</name>
    <title>ADS9324 documentation</title>
    <filename>md_docs_2index.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2installation</name>
    <title>Installation</title>
    <filename>md_docs_2installation.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2pga__and__calibration</name>
    <title>PGA, offset, and gain</title>
    <filename>md_docs_2pga__and__calibration.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2platform__integration</name>
    <title>Platform integration</title>
    <filename>md_docs_2platform__integration.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2quickstart</name>
    <title>Quick start</title>
    <filename>md_docs_2quickstart.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2registers</name>
    <title>Registers and SPI frames</title>
    <filename>md_docs_2registers.html</filename>
  </compound>
  <compound kind="page">
    <name>md_docs_2troubleshooting</name>
    <title>Troubleshooting</title>
    <filename>md_docs_2troubleshooting.html</filename>
  </compound>
  <compound kind="page">
    <name>index</name>
    <title>HF-ADS9324 Driver</title>
    <filename>index.html</filename>
    <docanchor file="index.html" title="HF-ADS9324 Driver">md_README</docanchor>
  </compound>
</tagfile>
