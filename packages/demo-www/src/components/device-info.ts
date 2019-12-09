import { DeviceInfo } from 'nimbus-bridge';

const template = document.createElement('template');
template.innerHTML = `
<slot></slot>
<button>ffff</button>
`;

class NimbusDeviceInfo extends HTMLElement {
  public constructor() {
    super();
    let shadowRoot = this.attachShadow({ mode: 'open' });
    shadowRoot.appendChild(template.content.cloneNode(true));
    this.addEventListener('click', e => {
      console.log(e);
      this.foo();
    });
  }

  public foo(): void {
    if (window.DeviceExtension !== undefined) {
      window.DeviceExtension.callbackWithSinglePrimitiveParam().then(
        (aaa: number): void => {
          console.log(aaa);
        }
      );
      //let aaa = window.DeviceExtension.getMethodsWithClosuresToPromisify()
      //console.log(aaa);
    }
  }

  public connectedCallback(): void {
    if (window.DeviceExtension !== undefined) {
      window.DeviceExtension.getDeviceInfo().then(
        (info: DeviceInfo): void => {
          console.log(JSON.stringify(info));
          let shadowRoot = this.shadowRoot;
          if (shadowRoot === null) return;
          let slot = shadowRoot.querySelector('slot');
          if (slot !== null) {
            slot.innerHTML = `
          <p>Manufacturer: ${info.manufacturer}</p>
          <p>Model: ${info.model}</p>
          <p>Platform: ${info.platform}</p>
          <p>Version: ${info.platformVersion}</p>
          <p>App Version: ${info.appVersion}</p>
        `;
          }
        }
      );
    }
  }
}

customElements.define('nimbus-device-info', NimbusDeviceInfo);

export default NimbusDeviceInfo;
