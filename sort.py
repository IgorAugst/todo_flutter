import copy

old_ori = [2,5,1,4,3]
new = [1,2,3,4,5]

old = copy.deepcopy(old_ori)

for item_old in old:
    if item_old not in new:
        idx = old.index(item_old)
        print(f"removendo {item_old} pos {idx}")
        old.remove(item_old)

for item_new in new:
    if item_new not in old:
        idx = new.index(item_new)
        print(f"inserindo {item_new} pos {idx}")
        old.insert(idx, item_new)

print(old)
i = 0

while i < len(old):
    if(old[i] != new[i]):
        old_idx = i
        new_idx = new.index(old[i])
        print(f'trocando {old[i]} de {old_idx} para {new_idx}')

        old.remove(old[i])
        old.insert(new_idx, new[new_idx])
        print(old)
        #i=0
    else:
        i += 1

print(old)