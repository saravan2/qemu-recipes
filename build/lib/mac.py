import click
import netaddr
import re
import random
import psutil

def lookup_oui(mac):
    remove_chars = '.-:ghijklmnopqrstuvwxyz!@#$%^&*()_+={};,<>/?"\''
    mac=mac.lower()
    mac=''.join([c for c in mac if c not in remove_chars])
    
    if len(mac) != 12:
        print('Unformatted Input is not 12 characters')
        return
    
    if netaddr.valid_mac(mac) is False:
        print('Invalid MAC Address')
        return
    
    try:
        oui = netaddr.EUI(mac).oui
        print(f'''OUI: {oui.registration().oui}''')
        for i in range(oui.reg_count):
            print(f'''Organization: {oui.registration(i).org}''')
            print(f'''Address: {", ".join(oui.registration(i).address)}''')
    except:
        print('OUI Not Registered')

@click.command()
@click.option('--lookup', '-l', type=str, help='MAC Addresses to lookup')
@click.option('--generate', '-g', type=click.Choice(['qemu', 'vmware', 'xen', 'microsoft']), help='Generates a random MAC Address')
@click.option('--silent', '-s', is_flag=True, help='Silent mode')
def mac(lookup, generate, silent):
    """
    Handy tool for looking up vendor details (OUI) in MAC addresses and generating random ones for VMs.
    When no options are provided, the MACs present in the local host are displayed.
    """
    if not silent:
        print('---------')
        print('')
    if lookup:
        macs = re.split(r'[,; ]', lookup)
        for mac in macs:
            print(f'Looking up MAC: {mac}')
            lookup_oui(mac)
            print('')
    elif generate:
        mac = []
        if generate == 'qemu':
            mac = [0x52, 0x54, 0x00,
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff)]
        elif generate == 'vmware':
            mac = [0x00, 0x05, 0x69,
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff)]
        elif generate == 'xen':
            mac = [0x00, 0x16, 0x3e,
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff)]
        elif generate == 'microsoft':
            mac = [0x00, 0x15, 0x5d,
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff),
                   random.randint(0x00, 0xff)]
        mac = ':'.join(map(lambda x: f'{x:02x}', mac))
        if not silent:
            print(f'Generated MAC: {mac}')
            print('')
        else:
            print(mac)
    else:
        print('Looking up MACs on this system:')
        nics = psutil.net_if_addrs()
        for nic in nics:
            for addr in nics[nic]:
                if addr.family == psutil.AF_LINK:
                    print(f'Interface: {nic}')
                    print(f'MAC: {addr.address}')
                    lookup_oui(addr.address)
                    print('')
    if not silent:
        print('---------')