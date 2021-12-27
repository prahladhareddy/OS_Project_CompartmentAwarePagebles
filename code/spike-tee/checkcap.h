reg_t curr_cap = p->get_csr(CSR_UCURRCAP);
reg_t capctl = p->get_csr(CSR_MCAPCTL);
reg_t no_cross_comp = p->get_csr(CSR_UNOCROSSCOMP);

// if((capctl & 0x3)==0x2){
	// throw trap_tee_comp_all_cond_fail(pc);
// }

if((capctl != 0)){
	p->set_csr(CSR_UTARGETCAP, (unsigned int)insn.i_imm());
	if((unsigned int)insn.i_imm() == 0){
		// go ahead
	}
	else if(((unsigned int)insn.i_imm() == 1) && (no_cross_comp == 1)){
		// go ahead
	}
	else if(((unsigned int)insn.i_imm() == curr_cap) && (no_cross_comp == 0)){
		// go ahead
	}
	else{
		throw trap_tee_compartment_exception(pc);
	}
}